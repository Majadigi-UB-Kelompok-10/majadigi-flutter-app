import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/operational/operational_registry.dart';

part 'operational_dto.freezed.dart';
part 'operational_dto.g.dart';

/// Model for JSON to Operational Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OperationalDto with _$OperationalDto {
  const OperationalDto({
    this.id,
    this.fkServiceListId,
    this.serviceUrl,
    this.address,
    this.operationalHour,
    this.socialMedia,
    this.createdAt
  });

  @override
  @JsonKey(name: 'operational_list_id')
  final String? id;

  @override
  @JsonKey(name: 'service_list_id')
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

  // Json Serializable
  factory OperationalDto.fromJson(Map<String, dynamic> json) => _$OperationalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OperationalDtoToJson(this);

  @ignore
  IsarOperationalRegistry toIsar() {
    return IsarOperationalRegistry()
      ..id = id!
      ..fkServiceListId = fkServiceListId!
      ..serviceUrl = serviceUrl!
      ..address = address!
      ..jsonOperationalHourData = operationalHour ?? {}
      ..jsonSocialMediaData = socialMedia ?? {}
      ..createdAt = createdAt!;
  }
}