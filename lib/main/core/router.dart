import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart' show SizedBox;
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/forget_password/password_reset_new_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/forget_password/password_reset_request_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/login/login_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/register/register_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/register/register_verification_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/dashboard_navigation.dart';
import 'package:majadigi_mobile_rebuild/main/ui/onboarding/onboarding_screen.dart';
import 'package:majadigi_mobile_rebuild/main/ui/search/search_page.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/service_detail_page.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:majadigi_mobile_rebuild/main/deferred_registry.dart';

part 'router.g.dart';

/// Initial List of Routes
final List<RouteBase> goRoutes = <RouteBase>[
  // Splash Screen
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),

  // Login
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),

  // Register
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterScreen(),
  ),

  // Register Verify
  GoRoute(
    path: '/verify-email',
    builder: (context, state) {
      if (state.extra == null) {
        if (context.mounted) {
          context.pop();
        }
      }

      final data = state.extra as Map<String, String>;
      final email = data["email"];

      if (email == null || email.isEmpty) {
        if (context.mounted) {
          context.pop();
        }
      }

      return RegisterVerificationScreen(
        email: email!,
      );
    },
  ),

  // Reset Password Request
  GoRoute(
    path: '/request-password-reset',
    builder: (context, state) => const PasswordResetRequestScreen(),
  ),

  // New Password Request Screen (ONLY AVAIlABLE IN DEEP LINK)
  GoRoute(
    path: '/reset-password',
    builder: (context, state) {
      final token = state.uri.queryParameters['token'];

      if (token == null || token.isEmpty) {
        return const SizedBox.shrink();
      }

      return PasswordResetNewScreen(token: token);
    },
  ),

  // Onboarding
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),

  // Homepage
  GoRoute(
    path: '/homepage',
    builder: (context, state) {
      final query = state.uri.queryParameters['nav'] ?? '0';
      return DashboardNavigation(initialIndex: int.parse(query));
    },
  ),

  // Search
  GoRoute(
    path: '/search',
    builder: (context, state) {
      final query = state.uri.queryParameters['q'] ?? '';
      return SearchPage(query: query);
    },
  ),

  // Service Detail
  GoRoute(
    path: '/page-detail',
    builder: (context, state) {
      if (state.extra == null) {
        if (context.mounted) {
          context.pop();
        }
        
        return const SizedBox.shrink();
      }

      final data = state.extra as Map<String, dynamic>;

      return ServiceDetailPage(
        serviceId: data['serviceId'],
        title: data['title'],
        description: data['description']
      );
    }
  ),

  // No Notification Page yet

  // Add Deferred Routes
  ...deferredRoutes,
];

/// GoRouter Instance
@riverpod
GoRouter router(Ref ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    routes: goRoutes,
  );
}