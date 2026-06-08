import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/notification/notification_entity.dart';

part 'notification_registry.g.dart';

@collection
class IsarNotificationLogRegistry {
  Id id = Isar.autoIncrement;

  String? title;
  String? body;
  String? payloadData; // Store the raw JSON or specific keys

  @Index()
  DateTime receivedAt = DateTime.now().toUtc();

  @Index()
  bool isRead = false;

  @ignore
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      payload: payloadData,
      receivedAt: receivedAt,
      isRead: isRead,
    );
  }
}