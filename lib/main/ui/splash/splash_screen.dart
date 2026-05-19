import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/sync_provider.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_logo.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_progress_indicator.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/widgets/majadigi_text.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We use a step integer to control the sequence of animations
    // 0 = Initial, 1 = Logo Visible, 2 = Text & Progress Visible
    final step = useState(0);
    final destination = '/homepage';

    // Control sync progress value
    final syncProgress = useState<double?>(null);

    useEffect(() {
      StreamSubscription<double>? syncSubscription;

      Future<void> initializeApp() async {
        // Step 1: Fade in Logo immediately
        step.value = 1;

        // Wait for the logo animation to finish before showing the progress bar
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!context.mounted) return;

        // Step 2: Show text and expand the progress bar container
        step.value = 2;

        try {
          // 1. Check Isar Database
          final isDataEmpty = await ref.read(isarDatabaseIsEmptyProvider.future);

          if (!isDataEmpty) {
            // If ALL data exists, fill the bar to 100% and proceed
            syncProgress.value = 1.0;
            await Future.delayed(const Duration(milliseconds: 500)); // Brief pause for visual Polish

            if (context.mounted) context.go(destination);
          } else {
            syncSubscription = ref
                .read(syncDatabaseServiceProvider)
                .executeSync()
                .listen(
                  (progress) {
                syncProgress.value = progress;

                if (progress >= 1.0) {
                  syncSubscription?.cancel();
                  if (context.mounted) {
                    context.go(destination);
                  }
                }
              },
              onError: (error) {
                debugPrint("Sync stream threw an error: $error");
                if (context.mounted) context.go(destination);
              },
              cancelOnError: true,
            );
          }
        } on TimeoutException {
          debugPrint("Sync process timed out.");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sync timed out. Loading offline mode.')),
            );

            context.go(destination);
          }
        } catch (e) {
          debugPrint("Error during initialization: $e");
          if (context.mounted) {
            context.go(destination);
          }
        }
      }

      initializeApp();

      // Cleanup
      return () {};
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
            MajadigiProgressIndicator(step: step, syncProgress: syncProgress),
          ],
        ),
      ),
    );
  }
}