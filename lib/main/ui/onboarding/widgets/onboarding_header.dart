import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, this.showLanguageChip = false});

  final bool showLanguageChip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/majadigi-main-logo-with-text.png',
          width: 124,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox(
              width: 124,
              height: 36,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MAJADIGI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1260D7),
                  ),
                ),
              ),
            );
          },
        ),
        if (showLanguageChip) const _LanguageChip(),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD1D9E6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF274266).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language_rounded, size: 17, color: Color(0xFF394B63)),
          SizedBox(width: 6),
          Text(
            'Bahasa Indonesia',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3C53),
            ),
          ),
        ],
      ),
    );
  }
}