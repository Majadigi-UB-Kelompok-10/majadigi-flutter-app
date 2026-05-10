import 'package:flutter/material.dart';
import '../../../../deferred/theme/app_theme.dart';

class TjTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const TjTabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.jdihBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.jdihBlue),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.jdihBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
