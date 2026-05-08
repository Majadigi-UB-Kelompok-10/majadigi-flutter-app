import 'package:flutter/material.dart' show ValueNotifier;
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/ui/sandbox/sandbox.dart';
import 'package:majadigi_mobile_rebuild/main/ui/splash/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Initial List of Routes
final List<RouteBase> goRoutes = <RouteBase>[
  // Splash Screen
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),

  // Homepage
  GoRoute(
    path: '/homepage',
    builder: (context, state) => const Sandbox(),
  ),
];

/// GoRouter Config
@riverpod
class RoutingConfigNotifier extends _$RoutingConfigNotifier {
  @override
  ValueNotifier<RoutingConfig> build() {
    final notifier = ValueNotifier<RoutingConfig>(
      RoutingConfig(
        routes: goRoutes
      ),
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  }

  // Method to get current list of route at runtime
  List<RouteBase> getRoutes() {
    return state.value.routes;
  }

  // Method to swap routes at runtime
  void updateRoutes(List<RouteBase> newRoutes) {
    state.value = RoutingConfig(routes: newRoutes);
  }
}

/// GoRouter Instance
@riverpod
GoRouter router(Ref ref) {
  final routingConfig = ref.watch(routingConfigProvider);

  return GoRouter.routingConfig(
    routingConfig: routingConfig,
  );
}