import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class JdihHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const JdihHeader({super.key, required this.child, this.height = 400});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: const BoxDecoration(
            color: AppTheme.jdihBlue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }
}