import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import '../../../../core/http.dart';
import '../../../../core/providers/category/category_providers.dart';
import '../../../../core/providers/service/service_providers.dart';
import './login_input_field.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> obscurePassword = useState(true);
    ValueNotifier<bool> rememberMe = useState(false);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final AuthNotifier authNotifier = ref.watch(authProvider.notifier);
    final authState = ref.watch(authProvider);
    final storage = ref.watch(secureStorageProvider);

    useEffect(() {
      Future<void> rememberEmail() async {
        final email = await storage.read(key: "user_email");

        if (email != null && email.isNotEmpty) {
          emailController.text = email;
        }
      }

      rememberEmail();
      return () {};
    }, const []);

    return Column(
      children: [
        LoginInputField(
          controller: emailController,
          hintText: 'E-mail',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        LoginInputField(
          controller: passwordController,
          hintText: 'Kata sandi',
          obscureText: obscurePassword.value,
          suffixIcon: IconButton(
            onPressed: () {
              obscurePassword.value = !obscurePassword.value;
            },
            icon: Icon(
              obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFFB3BED1),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(
              height: 18,
              width: 18,
              child: Checkbox(
                value: rememberMe.value,
                onChanged: (value) => rememberMe.value = value ?? false,
                side: const BorderSide(color: Color(0xFFBFC9DA), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                activeColor: const Color(0xFF0A63D2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Ingat saya',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5A71),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                context.push("/request-password-reset");
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lupa Kata Sandi?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5A71),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: authState.isLoading ? null : () async {
              // Ensure Auth Middleware is on and toggled
              // Also remove personalization to have clean slate
              await ref.read(clearAllFavoriteUseCaseProvider).execute();
              ref.read(addAuthMiddlewareProvider);
              ref.read(authFeatureToggleProvider.notifier).enableAuth();

              await authNotifier.login(emailController.text, passwordController.text);

              if (rememberMe.value) {
                await storage.write(key: 'user_email', value: emailController.text);
              } else {
                await storage.delete(key: 'user_email');
              }

              if (context.mounted && authState.hasValue && authState.value! == true) {
                // Check if user has set category preferences
                final prefs = await ref.read(getUserCategoryPreferencesProvider.future);
                if (context.mounted) {
                  if (prefs.length < 2) {
                    context.go('/personalization');
                  } else {
                    context.go('/homepage');
                  }
                }
              }

              if (context.mounted && authState.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authState.error.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A63D2),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0xFF0A63D2).withValues(alpha: 0.28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}