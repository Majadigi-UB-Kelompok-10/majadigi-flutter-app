import 'package:freezed_annotation/freezed_annotation.dart';

part 'operational_entity.freezed.dart';

/// Represent Operational Entity
@freezed
class OperationalEntity with _$OperationalEntity {
  const OperationalEntity({
    this.id,
    this.fkServiceListId,
    this.serviceUrl,
    this.address,
    this.operationalHour,
    this.socialMedia,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? fkServiceListId;

  @override
  final String? serviceUrl;

  @override
  final String? address;

  @override
  final Map<String, dynamic>? operationalHour;

  @override
  final Map<String, dynamic>? socialMedia;

  @override
  final DateTime? createdAt;

}