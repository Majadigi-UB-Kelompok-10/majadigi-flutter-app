import 'package:flutter/material.dart';

class MajadigiText extends StatelessWidget {
  final ValueNotifier<int> step;
  const MajadigiText({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: step,
      builder: (context, value, child) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          alignment: Alignment.centerRight,
          child: value >= 2
              ? AnimatedOpacity(
              opacity: value >= 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: Image.asset(
                  'assets/splash/majadigi-main-text.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 100,
                  fit: BoxFit.contain
              )
          )
              : const SizedBox(height: 100, width: 0),
        );
      },
    );
  }
}