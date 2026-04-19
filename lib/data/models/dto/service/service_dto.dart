import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/service/service_registry.dart';

part 'service_dto.freezed.dart';
part 'service_dto.g.dart';

/// Model for JSON to Service Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ServiceDto with _$ServiceDto {
  const ServiceDto({
    this.id,
    this.title,
    this.description,
    this.iconUrl,
    this.createdAt
  });

  @override
  @JsonKey(name: 'service_list_id')
  final String? id;

  @override
  final String? title;

  @override
  final String? description;

  @override
  final String? iconUrl;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory ServiceDto.fromJson(Map<String, dynamic> json) => _$ServiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDtoToJson(this);

  @ignore
  IsarServiceRegistry toIsar() {
    return IsarServiceRegistry()
      ..id = id!
      ..title = title!
      ..description = description ?? ''
      ..iconUrl = iconUrl ?? ''
      ..createdAt = createdAt!;
  }
}