import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart' hide routerProvider;
import 'package:majadigi_mobile_rebuild/main/core/router.dart' show routerProvider;
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/notification/notification_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/notification/notification_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/notification_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedAppSub;

  @override
  FutureOr<String?> build() async {
    ref.onDispose(() {
      _foregroundSub?.cancel();
      _openedAppSub?.cancel();
    });

    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.read(key: SecureStorageKeys.fcmToken);
    final guestMode = await ref.read(guestStatusProvider.future);

    if (guestMode) {
      await disableNotifications();
      _foregroundSub = null;
      _openedAppSub = null;
      return null;
    }

    if (token != null && token.isNotEmpty) {
      // Setup Listeners for incoming messages if token exists
      await _foregroundSub?.cancel();
      _foregroundSub = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      await _openedAppSub?.cancel();
      _openedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

      FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
        if (initialMessage != null) {
          _handleNotificationClick(initialMessage);
        }
      });

      await _syncTokenWithBackend(token);
      state = AsyncData(token);
      return token;
    }

    return null;
  }

  Future<void> enableNotifications() async {
    if (state.value != null) return;

    // To enable notification, you must be logged in so...
    final secureStorage = ref.read(secureStorageProvider);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final guestMode = await ref.read(guestStatusProvider.future);

    if (accessToken == null || accessToken.isEmpty || guestMode) {
      throw Exception("Must be Logged In to Activate Notification");
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 1. Request OS Permissions (Triggers the system dialog on iOS & Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get the unique FCM token
      final token = await messaging.getToken();
      if (token == null) return;

      // 3. Sync with Backend (Checking local Isar cache first)
      try {
        await _syncTokenWithBackend(token);
      } catch (e) {
        throw Exception("Something went wrong during sync with server");
      }

      state = AsyncData(token);

      // 4. Safely attach listeners by canceling any existing "ghost" subscriptions first
      await _foregroundSub?.cancel();
      _foregroundSub = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      await _openedAppSub?.cancel();
      _openedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }
    } else {
      // TODO: Remove on release
      debugPrint('User declined notification permissions');
    }
  }

  Future<void> _syncTokenWithBackend(String newToken) async {
    final storage = ref.read(secureStorageProvider);
    final String? lastSavedToken = await storage.read(key: SecureStorageKeys.fcmToken);

    if (newToken != lastSavedToken) {
      final dio = ref.read(dioProvider);
      final response = await dio.post("/user/auth/device-token", data: {
        "token": newToken,
        "platform": Platform.isAndroid ? "android" : "ios",
      }, options: Options(
        validateStatus: (status) => true,
      ));

      // If successful
      if (response.statusCode == 200) {
        await storage.write(key: SecureStorageKeys.fcmToken, value: newToken);
      } else {
        throw Exception();
      }
    }
  }

  Future<void> disableNotifications() async {
    // Tell your backend to stop sending notifications to this token
    final dio = ref.read(dioProvider);
    await dio.delete("/user/auth/device-token", data: {
      "platform": Platform.isAndroid ? "android" : "ios",
    }, options: Options(
      validateStatus: (status) => true,
    ));

    // whether the response is failed or not, just go through lol

    // Delete token in secure storage
    await ref.read(secureStorageProvider).delete(key: SecureStorageKeys.fcmToken);

    // Delete the token locally
    await _foregroundSub?.cancel();
    _foregroundSub = null;
    await _openedAppSub?.cancel();
    _openedAppSub = null;
    await FirebaseMessaging.instance.deleteToken();
    state = const AsyncData(null);
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    // TODO: Remove on release
    debugPrint('Foreground message received: ${message.notification?.title}');
    debugPrint('Payload data: ${message.data}');

    final isar = ref.read(isarProvider);

    final newLog = NotificationEntity(
      id: 0,
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      payload: message.data.toString(),
      receivedAt: DateTime.now(),
      isRead: false,
    );

    await ref.read(saveNotificationProvider(newLog).future);


    // If we are on the notifications screen, the watchNotifications provider
    // will automatically emit the new list because it's a Stream from Isar.
    // No further action needed here unless showing a local snackbar/toast.
  }

  Future<void> _handleNotificationClick(RemoteMessage message) async {
    // TODO: Remove on release
    debugPrint('User clicked notification. Routing with payload: ${message.data}');

    final router = ref.read(routerProvider);
    router.push('/notifications');
  }
}

/// Local Datasource for Notification
@riverpod
NotificationLocalDatasource _notificationLocalDatasource(Ref ref) {
  return NotificationLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Repository for Notification
@riverpod
NotificationRepository _notificationRepository(Ref ref) {
  return NotificationRepositoryImpl(localDatasource: ref.watch(_notificationLocalDatasourceProvider));
}

/// Watch All Notifications
@riverpod
Stream<List<NotificationEntity>> watchNotifications(Ref ref) {
  final repository = ref.watch(_notificationRepositoryProvider);
  return repository.watchNotifications();
}

/// Mark Notification As Read by ID
@riverpod
Future<bool> markNotificationAsRead(Ref ref, int id) async {
  final repository = ref.watch(_notificationRepositoryProvider);
  return await repository.markAsRead(id);
}

/// Mark ALL Notification as Read
@riverpod
Future<bool> markAllNotificationAsRead(Ref ref) async {
  final repository = ref.watch(_notificationRepositoryProvider);
  return await repository.markAllAsRead();
}

/// Save Notification
@riverpod
Future<bool> saveNotification(Ref ref, NotificationEntity entity) async {
  final repository = ref.watch(_notificationRepositoryProvider);
  return await repository.saveNotification(entity);
}