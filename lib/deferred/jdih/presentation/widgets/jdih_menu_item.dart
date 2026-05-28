import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class JdihMenuItem extends StatelessWidget {
  final String label;
  final IconData ikon;
  final VoidCallback? onTap;

  const JdihMenuItem({super.key, required this.label, required this.ikon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu $label diklik')),
            );
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.jdihBlue.withValues(alpha: 0.1),
            child: Icon(ikon, color: AppTheme.jdihBlue, size: 24),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
