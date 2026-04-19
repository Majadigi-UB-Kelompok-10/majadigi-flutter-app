import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/category/category_registry.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

/// Model for JSON to Category Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CategoryDto with _$CategoryDto {
  const CategoryDto({
    this.id,
    this.name,
    this.description,
    this.createdAt
  });

  @override
  @JsonKey(name: 'category_list_id')
  final String? id;

  @override
  final String? name;

  @override
  final String? description;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);

  @ignore
  IsarCategoryRegistry toIsar() {
    return IsarCategoryRegistry()
      ..id = id!
      ..name = name!
      ..description = description ?? ''
      ..createdAt = createdAt!;
  }
}