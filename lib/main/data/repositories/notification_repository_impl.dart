import 'package:majadigi_mobile_rebuild/main/data/datasources/notification/notification_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDatasource localDatasource;

  NotificationRepositoryImpl({required this.localDatasource});

  @override
  Future<bool> markAllAsRead() {
    return localDatasource.markAllNotificationAsRead();
  }

  @override
  Future<bool> markAsRead(int id) {
    return localDatasource.markNotificationAsRead(id);
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications() {
    return localDatasource.watchNotifications().map((notification) {
      return notification.map((notification) => notification.toEntity()).toList();
    });
  }

  @override
  Future<bool> saveNotification(NotificationEntity entity) {
    return localDatasource.saveNotification(entity);
  }
}