import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/sync_provider.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/notification/notification_registry.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/router_shell.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    IsarSchemaStorage().isarSchemaList,
    directory: dir.path,
    name: "majadigi-main",
    inspector: false,
  );

  final newLog = NotificationEntity(
    id: 0,
    title: message.notification?.title ?? 'No Title',
    body: message.notification?.body ?? 'No Body',
    payload: message.data.toString(),
    receivedAt: DateTime.now(),
    isRead: false,
  );

  await isar.writeTxn(() async {
    final registry = IsarNotificationLogRegistry()
      ..title = newLog.title
      ..body = newLog.body
      ..payloadData = newLog.payload
      ..receivedAt = newLog.receivedAt
      ..isRead = newLog.isRead;
    await isar.isarNotificationLogRegistrys.put(registry);
  });

  await isar.close();
}

/// Initialize custom dio, and firebase
Future<ProviderContainer> init() async {
  final container = ProviderContainer();

  // Initialize Database
  final isar = await container.read(openIsarProvider.future);
  final newContainer = ProviderContainer(overrides: [isarProvider.overrideWithValue(isar)]);

  // Dispose only after actually overriding the value of isar in the new container
  container.dispose();

  // Activate zstd & e-tag middleware to [dio]
  newContainer.read(dioProvider);
  newContainer.read(addETagMiddlewareProvider);
  newContainer.read(addZstdMiddlewareProvider);

  // Enable Auth Feature Toggle after Supabase is ready
  // If you are adding auth middleware, you should also
  // toggle auth toggler to activate redirect
  newContainer.read(authProvider.notifier);
  newContainer.read(authFeatureToggleProvider.notifier).enableAuth();
  newContainer.read(addAuthMiddlewareProvider);

  // Setup Timer to refresh token silently every 10 minutes
  Timer.periodic(Duration(minutes: 10), (timer) async {
    // If auth is on, then refresh
    // if guest is off, then refresh
    if (newContainer.read(authFeatureToggleProvider) && !(await newContainer.read(guestStatusProvider.future))) {
      await newContainer.read(authProvider.notifier).refresh();
    }
  });

  // Sync in background silently
  newContainer.read(startupSyncAllProvider.notifier).syncSilently();

  // Start Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Return a NEW container with isar provider override
  return newContainer;
}
