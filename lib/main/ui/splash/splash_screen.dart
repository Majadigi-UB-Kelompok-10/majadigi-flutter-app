import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a step integer to control the sequence of animations
    // 0 = Initial, 1 = Logo Visible, 2 = Text & Progress Visible
    final step = useState(0);

    useEffect(() {
      // Step 1: Fade in Logo immediately after widget mounts
      Future.microtask(() {
        if (context.mounted) step.value = 1;
      });

      // Step 2: Push logo, fade in text, and expand progress bar after 1.5s
      final sequenceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (context.mounted) step.value = 2;
      });

      // Step 3: Navigate after everything is done (Uncomment when needed)
      final navTimer = Timer(const Duration(milliseconds: 3800), () {
        if (context.mounted) {
          context.go('/homepage');
        }
      });

      return () {
        sequenceTimer.cancel();
        navTimer.cancel();
      };
    }, const []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16.0,
          children: [
            // Wrapped in a fixed height so the layout doesn't jump vertically
            // when the text appears
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main Logo
                  AnimatedOpacity(
                    opacity: step.value >= 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1200),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(12.0),
                      child: Image.asset('assets/splash/majadigi-main-logo.png'),
                    )
                  ),

                  // TEXT (Appears on the left)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.centerRight,
                    child: step.value >= 2
                        ? AnimatedOpacity(
                      opacity: step.value >= 2 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: Image.asset(
                        'assets/splash/majadigi-main-text.png',
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 100,
                        fit: BoxFit.contain
                      )
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // PROGRESS INDICATOR (Expands width)
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 1000),
            //   curve: Curves.easeOutCubic,
            //   width: step.value >= 2 ? MediaQuery.of(context).size.width * 0.5 : 0.0,
            //   height: 4.0,
            //   child: const ClipRRect(
            //     borderRadius: BorderRadius.all(Radius.circular(4)),
            //     child: LinearProgressIndicator(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}