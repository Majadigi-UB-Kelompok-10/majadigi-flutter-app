import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/integration/integration_registry.dart';

part 'integration_dto.freezed.dart';
part 'integration_dto.g.dart';

/// Model for JSON to Integration Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class IntegrationDto with _$IntegrationDto {
  const IntegrationDto({
    this.id,
    this.fkServiceListId,
    this.fkEndpointListId,
    this.title,
    this.iconUrl,
    this.createdAt,
  });

  @override
  @JsonKey(name: 'IntegrationListId')
  final String? id;

  @override
  @JsonKey(name: 'ServiceListId')
  final String? fkServiceListId;

  @override
  @JsonKey(name: 'EndpointListId')
  final String? fkEndpointListId;

  @override
  @JsonKey(name: 'Title')
  final String? title;

  @override
  @JsonKey(name: 'IconUrl')
  final String? iconUrl;

  @override
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;

  // Json Serializable
  factory IntegrationDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IntegrationDtoToJson(this);

  @ignore
  IsarIntegrationRegistry toIsar() {
    return IsarIntegrationRegistry()
      ..id = id!
      ..fkServiceListId = fkServiceListId!
      ..fkEndpointListId = fkEndpointListId!
      ..title = title!
      ..iconUrl = iconUrl!
      ..createdAt = createdAt!;
  }
}
