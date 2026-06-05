import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class JdihHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const JdihHeader({super.key, required this.child, this.height = 400});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: height,
      decoration: const BoxDecoration(
        color: AppTheme.jdihBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      padding: const EdgeInsets.all(0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: child,
        ),
      ),
    );
  }
}