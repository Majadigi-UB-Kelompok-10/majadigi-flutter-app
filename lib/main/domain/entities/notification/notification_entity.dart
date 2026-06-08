import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

/// Represent Notification Entity
@freezed
class NotificationEntity with _$NotificationEntity {
  const NotificationEntity({
    required this.id,
    this.title,
    this.body,
    this.payload,
    required this.receivedAt,
    required this.isRead,
  });

  @override
  final int id;

  @override
  final String? title;

  @override
  final String? body;

  @override
  final String? payload;

  @override
  final DateTime receivedAt;

  @override
  final bool isRead;
}