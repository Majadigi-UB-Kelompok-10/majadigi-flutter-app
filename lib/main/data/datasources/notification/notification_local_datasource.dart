import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/notification/notification_registry.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';

/// Represent the Contract for Notification Local Datasource.
/// Uses Isar Database.
abstract class NotificationLocalDatasource {
  Stream<List<IsarNotificationLogRegistry>> watchNotifications();
  Future<bool> saveNotification(NotificationEntity entity);
  Future<bool> markNotificationAsRead(int id);
  Future<bool> markAllNotificationAsRead();
}

/// Represent the Integration Local Datasource Implementation
class NotificationLocalDatasourceImpl implements NotificationLocalDatasource {
  final Isar _isar;
  NotificationLocalDatasourceImpl(this._isar);

  @override
  Future<bool> markAllNotificationAsRead() async {
    return await _isar.writeTxn(() async {
      final notifications = await _isar.isarNotificationLogRegistrys
          .where()
          .filter()
          .isReadEqualTo(false)
          .findAll();

      for (var notification in notifications) {
        notification.isRead = true;
      }
      await _isar.isarNotificationLogRegistrys.putAll(notifications);
      return true;
    });
  }

  @override
  Future<bool> markNotificationAsRead(int id) async {
    return await _isar.writeTxn(() async {
      final notification = await _isar.isarNotificationLogRegistrys.get(id);
      if (notification == null) return false;
      notification.isRead = true;
      await _isar.isarNotificationLogRegistrys.put(notification);
      return true;
    });
  }

  @override
  Stream<List<IsarNotificationLogRegistry>> watchNotifications() {
    return _isar.isarNotificationLogRegistrys.where().sortByReceivedAtDesc().watch(fireImmediately: true);
  }

  @override
  Future<bool> saveNotification(NotificationEntity entity) async {
    return await _isar.writeTxn(() async {
      final newLog = IsarNotificationLogRegistry()
        ..title = entity.title
        ..body = entity.body
        ..payloadData = entity.payload
        ..receivedAt = entity.receivedAt
        ..isRead = entity.isRead;

      await _isar.isarNotificationLogRegistrys.put(newLog);
      return true;
    });
  }
}
