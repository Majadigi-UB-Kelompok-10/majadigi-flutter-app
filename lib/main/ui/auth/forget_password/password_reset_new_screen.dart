import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import '../shared/auth_header.dart';

class PasswordResetNewScreen extends HookConsumerWidget {
  final String token;
  const PasswordResetNewScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // Ensure that token does exist
      if (token.isEmpty) {
        context.pop();
      }

      return;
    }, const []);

    // Text Controller
    final newPassword = useTextEditingController();
    final confirmNewPassword = useTextEditingController();

    Future<void> handleReset() async {
      // Check if any field is empty
      if (newPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kata Sandi baru tidak boleh kosong!"))
        );
        return;
      }

      if (confirmNewPassword.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ulangi Kata Sandi tidak boleh kosong!"))
        );
        return;
      }

      if (newPassword.text != confirmNewPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ulangi Kata Sandi tidak sesuai dengan Kata Sandi!"))
        );
        return;
      }

      // Hit the endpoint
      final (success, message) = await ref.read(authRepositoryProvider).setNewPassword(token, newPassword.text, confirmNewPassword.text);

      if (context.mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message))
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password Successfully reset! Redirecting in 3 Seconds!"))
        );

        // Navigate back to login or success screen after a timer
        await Future.delayed(Duration(seconds: 3), () {
          if (context.mounted) {
            context.go('/onboarding');
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A63D2),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            const _TopBand(),
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const OnboardingHeader(showLanguageChip: false),
                            const SizedBox(height: 36),
                            const Text(
                              'Buat Kata Sandi Baru',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF13253E)),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Masukkan kata sandi baru Anda untuk\nmengamankan akun.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF59697F)),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: newPassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Masukkan kata sandi baru',
                                filled: true,
                                fillColor: const Color(0xFFF3F5FA),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFD3D9E6)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: confirmNewPassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Ulangi kata sandi baru',
                                filled: true,
                                fillColor: const Color(0xFFF3F5FA),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFD3D9E6)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: handleReset,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2146E4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text('Simpan Kata Sandi', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                    Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBand extends StatelessWidget {
  const _TopBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      decoration: const BoxDecoration(
        color: Color(0xFF0A63D2),
      ),
    );
  }
}
