import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/core/router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../deferred/transjatim/presentation/screens/tj_screen.dart' deferred as transjatim_screen;

part 'deferred_registry.g.dart';

/// Register Routes to existing GoRouter
@riverpod
Future<void> registerDeferredRoute(Ref ref) async {
  final config = ref.watch(routingConfigProvider.notifier).getRoutes();

  // Register Route Here
  config.add(
    GoRoute(
      path: '/transjatim',
      builder: (context, state) => FutureBuilder(
        future: transjatim_screen.loadLibrary(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error loading page: ${snapshot.error}')));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return transjatim_screen.TjScreen();
          }

          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    ),
  );

  ref.read(routingConfigProvider.notifier).updateRoutes(config);
}
