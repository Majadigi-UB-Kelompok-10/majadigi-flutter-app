import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/service/service_registry.dart';

part 'normalized_service_category_dto.freezed.dart';
part 'normalized_service_category_dto.g.dart';

/// Model for JSON to Service Entity Object
/// A Special Normalized Version of Services that includes Category Ids
/// ```
/// {
///   id: "<uuid>",
///   title: "<string>",
///   description: "<string>",
///   iconUrl: "<string>",
///   categoryIds: [
///     "<uuid>",
///     "<uuid>"
///   ],
///   createdAt: "<datetime>"
/// }
/// ```
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NormalizedServiceCategoryDto with _$NormalizedServiceCategoryDto {
  const NormalizedServiceCategoryDto({
    this.id,
    this.title,
    this.description,
    this.iconUrl,
    this.categoryIds,
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
  @JsonKey(defaultValue: [])
  final List<String>? categoryIds;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory NormalizedServiceCategoryDto.fromJson(Map<String, dynamic> json) => _$NormalizedServiceCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NormalizedServiceCategoryDtoToJson(this);

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