import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/sync_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majadigi_mobile_rebuild/main/ui/router_shell.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';

import 'main/core/providers/auth/auth_provider.dart';

/// Entrypoint of the App
Future<void> main() async {
  // Required
  WidgetsFlutterBinding.ensureInitialized();

  // Init
  await init().then((container) {
    // Run App
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const RouterShell(),
      ),
    );
  });
}

/// Initialize stac with custom parser, custom dio, and Supabase
Future<ProviderContainer> init() async {
  final container = ProviderContainer();

  // Initialize Database
  final isar = await container.read(openIsarProvider.future);
  container.dispose();

  final newContainer = ProviderContainer(overrides: [isarProvider.overrideWithValue(isar)]);

  // Activate zstd & e-tag middleware to [dio]
  newContainer.read(dioProvider);
  newContainer.read(addETagMiddlewareProvider);
  newContainer.read(addZstdMiddlewareProvider);

  await Supabase.initialize(
    url: 'https://nhsdrdhzkogczngslvvh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5oc2RyZGh6a29nY3puZ3NsdnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNzQ4NjEsImV4cCI6MjA4ODg1MDg2MX0.aImo2p-pPCjyHWPRw43Hlhppc9SkkKyuG6c2Qj1j0nM',
  );

  // Enable Auth Feature Toggle after Supabase is ready
  // If you are adding auth middleware, you should also
  // toggle auth toggler to activate redirect
  newContainer.read(authProvider.notifier);
  newContainer.read(authFeatureToggleProvider.notifier).enableAuth();
  newContainer.read(addAuthMiddlewareProvider);

  // Setup Timer to refresh token silently every 10 minutes
  Timer.periodic(Duration(minutes: 10), (timer) async {
    await newContainer.read(authProvider.notifier).refresh();
  });

  // Sync in background silently
  newContainer.read(startupSyncAllProvider.notifier).syncSilently();

  // Return a NEW container with isar provider override
  return newContainer;
}
