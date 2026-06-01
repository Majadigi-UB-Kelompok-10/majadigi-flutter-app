import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';

import '../shared/auth_header.dart';

class PasswordResetRequestScreen extends HookConsumerWidget {
  const PasswordResetRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBanner = useState(false);
    final isLoading = useState(false);
    final emailController = useTextEditingController();

    Future<void> sendReset() async {
      if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong.')));
        return;
      }

      // Email Check
      final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailRegExp.hasMatch(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email tidak valid.")));
        return;
      }

      isLoading.value = true;
      try {
        final result = await ref.read(authRepositoryProvider).resetPassword(emailController.text);
        if (result) {
          showBanner.value = true;
          // Auto hide banner after 4 seconds
          Future.delayed(const Duration(seconds: 4), () {
            if (context.mounted) {
              showBanner.value = false;
            }
          });
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim tautan reset password. Pastikan email yang Anda masukkan terdaftar dalam CampusHub!')));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const OnboardingHeader(showLanguageChip: false),
                                const SizedBox(height: 24),
                                const Text(
                                  'Atur Ulang Kata Sandi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF13253E),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Masukkan email untuk mengatur\nulang kata sandi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF59697F)),
                                ),
                                const SizedBox(height: 18),
                                TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    filled: true,
                                    fillColor: const Color(0xFFF3F5FA),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color(0xFFD3D9E6)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: isLoading.value ? null : sendReset,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2146E4),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    ),
                                    child: isLoading.value 
                                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                      : const Text('Kirim', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Center(child: Text('Belum menerima Tautan?', style: TextStyle(color: Color(0xFF59697F)))),
                                TextButton(
                                  onPressed: isLoading.value ? null : sendReset,
                                  child: const Text('Kirim Kembali', style: TextStyle(color: Color(0xFF0A63D2), fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(height: 160),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (showBanner.value)
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: _InfoBanner(
                  text: 'Email Untuk Mengatur Ulang Kata Sandi Telah Terkirim',
                  onClose: () => showBanner.value = false,
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF007D58),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFD5F6EA), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.25, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(onTap: onClose, child: const Icon(Icons.close, color: Color(0xFFBAEADA), size: 20)),
        ],
      ),
    );
  }
}
