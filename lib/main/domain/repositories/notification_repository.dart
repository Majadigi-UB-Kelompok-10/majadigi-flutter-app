import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';

/// Represent Contract for Notification
abstract class NotificationRepository {
  // SWR Specific Implementation
  Stream<List<NotificationEntity>> watchNotifications();

  // General Use Case
  Future<bool> saveNotification(NotificationEntity entity);
  Future<bool> markAsRead(int id);
  Future<bool> markAllAsRead();
}