import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> enableNotifications() async {
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

      state = AsyncData(token);

      // 3. Sync with Backend (Checking local Isar cache first)
      await _syncTokenWithBackend(token);

      // 4. Setup Listeners for incoming messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }
    } else {
      print('User declined notification permissions');
    }
  }

  Future<void> _syncTokenWithBackend(String newToken) async {
    final storage = ref.watch(secureStorageProvider);
    final String? lastSavedToken = await storage.read(key: SecureStorageKeys.fcmToken);

    if (newToken != lastSavedToken) {
      // TODO: POST request to your colleague's backend endpoint

      await storage.write(key: SecureStorageKeys.fcmToken, value: newToken);
    }
  }

  Future<void> disableNotifications() async {
    // Tell your backend to stop sending notifications to this token
    // TODO: POST /api/v1/notifications/disable

    // Delete the token locally
    await FirebaseMessaging.instance.deleteToken();
    state = const AsyncData(null);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');
    print('Payload data: ${message.data}');
  }

  void _handleNotificationClick(RemoteMessage message) {
    print('User clicked notification. Routing with payload: ${message.data}');
  }
}