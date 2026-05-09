import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_logo.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_progress_indicator.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_text.dart';

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

      // Step 3: Navigate after everything is done
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
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main Logo
                  MajadigiLogo(step: step),

                  // TEXT (Appears on the left)
                  MajadigiText(step: step),
                ],
              ),
            ),

            // PROGRESS INDICATOR (Expands width)
            MajadigiProgressIndicator(step: step),
          ],
        ),
      ),
    );
  }
}