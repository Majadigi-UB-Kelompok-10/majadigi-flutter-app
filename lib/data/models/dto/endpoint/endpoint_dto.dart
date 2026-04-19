import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/endpoint/endpoint_registry.dart';

part 'endpoint_dto.freezed.dart';
part 'endpoint_dto.g.dart';

/// Model for JSON to Endpoint Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EndpointDto with _$EndpointDto {
  const EndpointDto({
    this.id,
    this.slugName,
    this.pageUrl,
    this.createdAt
  });

  @override
  @JsonKey(name: 'endpoint_list_id')
  final String? id;

  @override
  final String? slugName;

  @override
  final String? pageUrl;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory EndpointDto.fromJson(Map<String, dynamic> json) => _$EndpointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EndpointDtoToJson(this);

  @ignore
  IsarEndpointRegistry toIsar() {
    return IsarEndpointRegistry()
      ..id = id!
      ..slugName = slugName!
      ..pageUrl = pageUrl!
      ..createdAt = createdAt!;
  }
}