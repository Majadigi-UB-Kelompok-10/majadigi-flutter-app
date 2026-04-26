import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/operational/operational_registry.dart';

part 'operational_dto.freezed.dart';
part 'operational_dto.g.dart';

/// Model for JSON to Operational Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class OperationalDto with _$OperationalDto {
  const OperationalDto({
    this.id,
    this.fkServiceListId,
    this.serviceUrl,
    this.address,
    this.operationalHour,
    this.socialMedia,
    this.createdAt,
  });

  @override
  @JsonKey(name: 'OperationalListId')
  final String? id;

  @override
  @JsonKey(name: 'ServiceListId')
  final String? fkServiceListId;

  @override
  @JsonKey(name: 'ServiceUrl')
  final String? serviceUrl;

  @override
  @JsonKey(name: 'Address')
  final String? address;

  @override
  @JsonKey(name: 'OperationalHour')
  final Map<String, dynamic>? operationalHour;

  @override
  @JsonKey(name: 'SocialMedia')
  final Map<String, dynamic>? socialMedia;

  @override
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;

  // Json Serializable
  factory OperationalDto.fromJson(Map<String, dynamic> json) =>
      _$OperationalDtoFromJson(json);

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
