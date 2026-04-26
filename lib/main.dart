import 'package:stac/stac.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majadigi_mobile_rebuild/ui/router.dart';
import 'package:majadigi_mobile_rebuild/core/http.dart';
import 'package:majadigi_mobile_rebuild/core/storage.dart';

/// Entrypoint of the App
Future<void> main() async {
  // Required
  WidgetsFlutterBinding.ensureInitialized();

  // Init
  final container = await init();

  runApp(
    UncontrolledProviderScope(container: container, child: const RouterShell()),
  );
}

/// Initialize stac with custom parser, custom dio, and Supabase
Future<ProviderContainer> init() async {
  final container = ProviderContainer();
  final dio = container.read(dioProvider);

  // Activate zstd & e-tag middleware to [dio]
  container.read(addZstdMiddlewareProvider);
  container.read(addETagMiddlewareProvider);

  // Initialize stac with custom parser & our own dio
  await Stac.initialize(dio: dio, parsers: [], actionParsers: []);

  await Supabase.initialize(
    url: 'https://nhsdrdhzkogczngslvvh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5oc2RyZGh6a29nY3puZ3NsdnZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNzQ4NjEsImV4cCI6MjA4ODg1MDg2MX0.aImo2p-pPCjyHWPRw43Hlhppc9SkkKyuG6c2Qj1j0nM',
  );

  // Initialize Database
  final isar = await container.read(openIsarProvider.future);

  // Return a NEW container with isar provider override
  return ProviderContainer(overrides: [isarProvider.overrideWithValue(isar)]);
}
