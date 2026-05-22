import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';

part 'service_dto.freezed.dart';
part 'service_dto.g.dart';

/// Model for JSON to Service Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class ServiceDto with _$ServiceDto {
  const ServiceDto({
    this.id,
    this.title,
    this.longTitle,
    this.description,
    this.iconUrl,
    this.createdAt,
  });

  @override
  @JsonKey(name: 'ServiceListID')
  final String? id;

  @override
  @JsonKey(name: 'Title')
  final String? title;

  @override
  @JsonKey(name: 'LongTitle')
  final String? longTitle;

  @override
  @JsonKey(name: 'Description')
  final String? description;

  @override
  @JsonKey(name: 'IconUrl')
  final String? iconUrl;

  @override
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;

  // Json Serializable
  factory ServiceDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDtoToJson(this);

  @ignore
  IsarServiceRegistry toIsar() {
    return IsarServiceRegistry()
      ..id = id!
      ..title = title!
      ..longTitle = longTitle ?? ''
      ..description = description ?? ''
      ..iconUrl = iconUrl ?? ''
      ..createdAt = createdAt!;
  }
}
