import 'package:flutter/material.dart';

class MajadigiLogo extends StatelessWidget {
  final ValueNotifier<int> step;
  const MajadigiLogo({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: step,
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value >= 1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 1200),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/splash/majadigi-main-logo.png'),
          ),
        );
      },
    );
  }
}