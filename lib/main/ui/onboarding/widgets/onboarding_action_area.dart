import 'package:flutter/material.dart';

class OnboardingActionArea extends StatelessWidget {
  const OnboardingActionArea({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onSkipPressed,
    this.onSupportPressed,
  });

  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onSkipPressed;
  final VoidCallback? onSupportPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B63D3),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onRegisterPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEAF1FF),
              foregroundColor: const Color(0xFF0B5CD1),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Belum punya akun? Daftar dulu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.black, // Line color
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10), // Space between line and text
                child: Text("ATAU"),
              ),
              Expanded(
                child: Divider(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onSkipPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDEDED),
              foregroundColor: const Color(0xFFE74C3C),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Lewati',
              style: TextStyle(
                color: Color(0xFFE74C3C),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text.rich(
            TextSpan(
              text: 'Butuh bantuan? ',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF68778D),
              ),
              children: [
                TextSpan(
                  text: 'Hubungi kami',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0B63D3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}