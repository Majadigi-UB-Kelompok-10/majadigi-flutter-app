import 'package:flutter/material.dart';

class MajadigiProgressIndicator extends StatelessWidget {
  final ValueNotifier<int> step;
  const MajadigiProgressIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: step,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          width: value >= 2 ? MediaQuery.of(context).size.width * 0.5 : 0.0,
          height: 4.0,
          child: const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
  }
}