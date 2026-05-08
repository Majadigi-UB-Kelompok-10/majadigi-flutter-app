import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';

part 'normalized_service_category_dto.freezed.dart';
part 'normalized_service_category_dto.g.dart';

/// Model for JSON to Service Entity Object
/// A Special Normalized Version of Services that includes Category Ids
/// ```
/// {
///   service_list_id: "<uuid>",
///   title: "<string>",
///   description: "<string>",
///   icon_url: "<string>",
///   category_ids: [
///     "<uuid>",
///     "<uuid>"
///   ],
///   created_at: "<datetime>"
/// }
/// ```
@freezed
@JsonSerializable(explicitToJson: true)
class NormalizedServiceCategoryDto with _$NormalizedServiceCategoryDto {
  const NormalizedServiceCategoryDto({
    this.id,
    this.title,
    this.description,
    this.iconUrl,
    this.categoryIds,
    this.createdAt,
  });

  @override
  @JsonKey(name: 'ServiceListID')
  final String? id;

  @override
  @JsonKey(name: 'Title')
  final String? title;

  @override
  @JsonKey(name: 'Description')
  final String? description;

  @override
  @JsonKey(name: 'IconUrl')
  final String? iconUrl;

  @override
  @JsonKey(defaultValue: [], name: 'CategoryIds')
  final List<String>? categoryIds;

  @override
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;

  // Json Serializable
  factory NormalizedServiceCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$NormalizedServiceCategoryDtoFromJson(json);

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
