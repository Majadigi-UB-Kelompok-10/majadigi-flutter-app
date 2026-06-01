import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import '../shared/auth_header.dart';

class RegisterVerificationScreen extends HookWidget {
  final String email;
  const RegisterVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final showBanner = useState(true);
    final bannerTimer = useRef<Timer?>(null);

    useEffect(() {
      bannerTimer.value = Timer(const Duration(seconds: 4), () {
        showBanner.value = false;
      });

      return () => bannerTimer.value?.cancel();
    }, []);

    void dismissBanner() {
      bannerTimer.value?.cancel();
      showBanner.value = false;
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
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: constraints.maxHeight),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 18, 16, 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const OnboardingHeader(showLanguageChip: false),
                                    const SizedBox(height: 64),
                                    const Center(
                                      child: _EmailIconCircle(),
                                    ),
                                    const SizedBox(height: 28),
                                    const Text(
                                      'Verifikasi Terkirim!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 40 / 2,
                                        height: 1.2,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF13253E),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Tautan verifikasi telah dikirim ke email\nAnda. Silakan periksa kotak masuk atau\nfolder spam.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.45,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF4A596D),
                                      ),
                                    ),
                                    const SizedBox(height: 54),
                                    const SizedBox(
                                      height: 52,
                                      child: _GoToDashboardButton(),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Belum menerima Tautan?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF5B6678),
                                      ),
                                    ),
                                    _ResendLinkButton(email: email),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (showBanner.value)
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 18,
                          child: _AccountCreatedBanner(onClose: dismissBanner),
                        ),
                    ],
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

class _EmailIconCircle extends StatelessWidget {
  const _EmailIconCircle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(48),
        ),
        child: const Icon(
          Icons.mark_email_read_outlined,
          size: 52,
          color: Color(0xFF0B60CF),
        ),
      ),
    );
  }
}

class _GoToDashboardButton extends StatelessWidget {
  const _GoToDashboardButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go("/onboarding");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF095CC7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Masuk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 18, color: Colors.white),
        ],
      ),
    );
  }
}

class _ResendLinkButton extends ConsumerWidget {
  final String email;
  const _ResendLinkButton({required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final success = await ref.read(authRepositoryProvider).resendEmailVerification(email);

        if (context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tautan verifikasi telah dikirim ulang.')),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tautan verifikasi gagal dikirim.')),
          );
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0A63D2),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      child: const Text('Kirim Kembali'),
    );
  }
}

class _AccountCreatedBanner extends StatelessWidget {
  const _AccountCreatedBanner({required this.onClose});

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
            color: const Color(0xFF003D2B).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFD5F6EA), size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Akun Berhasil Dibuat Silakan\nVerifikasi Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, color: Color(0xFFBAEADA), size: 20),
            ),
          ),
        ],
      ),
    );
  }
}