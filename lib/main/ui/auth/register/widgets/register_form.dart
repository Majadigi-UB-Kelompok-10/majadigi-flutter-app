import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart' hide routerProvider;
import 'package:majadigi_mobile_rebuild/main/core/router.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/register/register_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/register/provider/register_nav_index_provider.dart';

import 'form_widget/register_first_form.dart';
import 'form_widget/register_second_form.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form Controller
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final nikController = useTextEditingController();
    final addressController = useTextEditingController();
    final birthController = useTextEditingController();
    final genderController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Use State for Gender
    final genderPick = useState<String>("");

    // Page Controller
    final pageController = usePageController();

    (bool, String?) validateForm() {
      final fields = {
        'Nama Depan': firstNameController,
        'Nama Belakang': lastNameController,
        'Nomor HP': phoneController,
        'Email': emailController,
        'NIK': nikController,
        'Alamat': addressController,
        'Tanggal Lahir': birthController,
        'Jenis Kelamin': genderController,
        'Kata Sandi': passwordController,
        'Konfirmasi Kata Sandi': confirmPasswordController
      };

      // Check for empty fields
      for (final entry in fields.entries) {
        if (entry.value.text.trim().isEmpty) {
          return (false, '${entry.key} tidak boleh kosong');
        }
      }

      // Gender value
      if (genderPick.value.trim().isEmpty) {
        return (false, "Jenis Kelamin tidak boleh kosong!");
      }

      // Email Check
      final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailRegExp.hasMatch(emailController.text)) {
        return (false, 'Email invalid!');
      }

      // NIK Check
      if (nikController.text.trim().length != 16) {
        return (false, 'NIK harus 16 digit!');
      }

      // Password Minimum Digit Check
      if (passwordController.text.length < 8) {
        return (false, 'Kata Sandi harus minimal 8 karakter!');
      }

      // Password Confirm = Password
      if (passwordController.text != confirmPasswordController.text) {
        return (false, 'Kata Sandi tidak sesuai dengan ulangi kata sandi!');
      }

      return (true, null);
    }

    String formatPhoneNumber(String rawPhone) {
      // 1. Remove all spaces, dashes, and non-numeric characters (except '+')
      String cleaned = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

      // 2. If it already starts with +62, return it as is
      if (cleaned.startsWith('+62')) {
        return cleaned;
      }

      // 3. If it starts with '62' (missing the +), add the +
      if (cleaned.startsWith('62')) {
        return '+$cleaned';
      }

      // 4. If it starts with '0', replace the '0' with '+62'
      if (cleaned.startsWith('0')) {
        return '+62${cleaned.substring(1)}';
      }

      // 5. If it starts with '8' (e.g., user just typed 81122223333), prepend +62
      if (cleaned.startsWith('8')) {
        return '+62$cleaned';
      }

      // Fallback: just return the cleaned version if it doesn't match expected patterns
      return cleaned;
    }

    Future<void> sendRegistration() async {
      // Package it into an entity since it's a pain to send the whole thing
      final RegisterEntity entity = RegisterEntity(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        address: addressController.text,
        nik: nikController.text,
        email: emailController.text,
        phone: formatPhoneNumber(phoneController.text),
        birthDate: birthController.text,
        gender: genderPick.value,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text
      );

      final (isSuccess, message) = await ref.read(authRepositoryProvider).register(entity);

      // If registration fail
      if (!isSuccess && context.mounted) {
        final messenger = ScaffoldMessenger.of(context);

        messenger.showSnackBar(
          SnackBar(content: Text(message))
        );

        // messenger.showMaterialBanner(
        //   MaterialBanner(
        //     content: Text(message),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           messenger.clearMaterialBanners();
        //
        //           final (isValid, errMessage) = validateForm();
        //
        //           if (isValid && context.mounted) {
        //             sendRegistration();
        //           }
        //
        //           if (!isValid && context.mounted) {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //                 SnackBar(content: Text(errMessage ?? "Something Went Wrong"))
        //             );
        //           }
        //         },
        //         child: const Text("Retry"),
        //       ),
        //       TextButton(
        //         onPressed: () => messenger.clearMaterialBanners(),
        //         child: const Text('Dismiss'),
        //       ),
        //     ],
        //   )
        // );
      }

      // Only redirect if register is successful
      if (isSuccess && context.mounted) {
        context.pushReplacement('/verify-email', extra: {
          "email": emailController.text
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // PageView of first and second form
        ExpandablePageView(
          controller: pageController,
          onPageChanged: (newIndex) => ref.read(registerNavIndexProvider.notifier).setIndex(newIndex),
          children: [
            RegisterFirstForm(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              phoneController: phoneController,
              emailController: emailController,
            ),
            RegisterSecondForm(
              nikController: nikController,
              addressController: addressController,
              birthController: birthController,
              genderController: genderController,
              onGenderChanged: (value) => genderPick.value = value ?? "",
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),
          ]
        ),

        const SizedBox(height: 24),

        // Span button to redirect to login
        _RedirectToLoginWidget(),

        const SizedBox(height: 18),

        // Button to continue in the registration progress
        _ContinueButton(pageController: pageController, validateForm: validateForm, sendRegistration: sendRegistration),

        const SizedBox(height: 10),

        // Hidden Button only visible in index 2 to go back
        _BackButton(pageController: pageController),
      ],
    );
  }
}

class _RedirectToLoginWidget extends HookConsumerWidget {
  const _RedirectToLoginWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginRecognizer = useMemoized(() => TapGestureRecognizer());

    useEffect(() {
      loginRecognizer.onTap = () {
        if (context.mounted) {
          final router = ref.read(routerProvider);
          final matches = router.routerDelegate.currentConfiguration.matches;

          String? previousLocation;
          if (matches.length > 1) {
            previousLocation = matches[matches.length - 2].matchedLocation;
          }

          if (previousLocation == '/login') {
            context.pop();
            return;
          }

          context.push("/login");
        }
      };

      return loginRecognizer.dispose;
    }, [loginRecognizer]);

    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Sudah punya akun? ',
          style: const TextStyle(color: Color(0xFF59697F)),
          children: [
            TextSpan(
              recognizer: loginRecognizer,
              text: 'Masuk',
              style: const TextStyle(color: Color(0xFF0A63D2), fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends ConsumerWidget {
  final PageController pageController;
  final (bool, String?) Function() validateForm;
  final Future<void> Function() sendRegistration;
  const _ContinueButton({required this.pageController, required this.validateForm, required this.sendRegistration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(registerNavIndexProvider);

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () async {
          if (index == 0) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut
            );
          }

          if (index == 1) {
            final (isValid, message) = validateForm();

            if (isValid && context.mounted) {
              await sendRegistration();
            }

            if (!isValid && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message ?? "Something Went Wrong"))
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2146E4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                ((index == 0) ? 'Selanjutnya' : "Daftar"),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends ConsumerWidget {
  final PageController pageController;
  const _BackButton({required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(registerNavIndexProvider);

    if (index == 1) {
      return TextButton.icon(
        onPressed: () => pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
        ),
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text('Kembali'),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF2146E4),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    return SizedBox.shrink();
  }
}