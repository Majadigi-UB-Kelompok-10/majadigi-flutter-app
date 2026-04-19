import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/integration/integration_registry.dart';

part 'integration_dto.freezed.dart';
part 'integration_dto.g.dart';

/// Model for JSON to Integration Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class IntegrationDto with _$IntegrationDto {
  const IntegrationDto({
    this.id,
    this.fkServiceListId,
    this.fkEndpointListId,
    this.title,
    this.iconUrl,
    this.createdAt
  });

  @override
  @JsonKey(name: 'integration_list_id')
  final String? id;

  @override
  @JsonKey(name: 'service_list_id')
  final String? fkServiceListId;

  @override
  @JsonKey(name: 'endpoint_list_id')
  final String? fkEndpointListId;

  @override
  final String? title;

  @override
  final String? iconUrl;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory IntegrationDto.fromJson(Map<String, dynamic> json) => _$IntegrationDtoFromJson(json);

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