import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'widgets/onboarding_action_area.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_hero_card.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect user to homepage if already logged in before
    useEffect(() {
      Future<void> checkUserAuthState() async {
        if (!context.mounted) return;

        final isLoggedIn = await ref.read(authRepositoryProvider).isLoggedIn();

        final isGuest = await ref.read(guestStatusProvider.future);

        if (context.mounted) {
          if (isLoggedIn) {
            context.go('/homepage');
          }

          if (isGuest) {
            // Only disable auth without removing personalization
            ref.read(removeAuthMiddlewareProvider);
            ref.read(authFeatureToggleProvider.notifier).disableAuth();

            context.go('/homepage');
          }
        }
      }

      checkUserAuthState();

      return () {};
    }, const []);

    return Scaffold(
      backgroundColor: const Color(0xFF0A63D2),
      body: Stack(
        children: [
          const _TopBand(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 18, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OnboardingHeader(),
                                SizedBox(height: 22),

                                OnboardingHeroCard(),
                                SizedBox(height: 28),

                                _WelcomeSection(),
                                SizedBox(height: 32),

                                OnboardingActionArea(
                                  onLoginPressed: () {
                                    context.push('/login');
                                  },
                                  onRegisterPressed: () {
                                    context.push('/register');
                                  },
                                  onSkipPressed: () async {
                                    // Attempt to remove all personalisation
                                    // Features and Authentication
                                    await ref.read(authProvider.notifier).logout();
                                    await ref.read(clearAllFavoriteUseCaseProvider).execute();
                                    ref.read(removeAuthMiddlewareProvider);
                                    ref.read(authFeatureToggleProvider.notifier).disableAuth();

                                    // Set Guest Mode
                                    ref.read(guestStatusProvider.notifier).enableGuest();

                                    if (context.mounted) {
                                      context.go("/homepage");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBand extends StatelessWidget {
  const _TopBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0158C7),
            Color(0xFF0A63D2),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Selamat datang di\nMajadigi!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 29,
            height: 1.12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17253A),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Platform layanan publik Jawa Timur yang\nsimple, cerdas, dan terhubung.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w400,
            color: Color(0xFF5E6B80),
          ),
        ),
      ],
    );
  }
}
