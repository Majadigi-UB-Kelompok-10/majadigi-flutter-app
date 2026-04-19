import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/image/image_registry.dart';

part 'image_dto.freezed.dart';
part 'image_dto.g.dart';

/// Model for JSON to Image Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ImageDto with _$ImageDto {
  const ImageDto({
    this.id,
    this.fkServiceListId,
    this.imageUrl,
    this.semanticLabel,
    this.createdAt
  });

  @override
  @JsonKey(name: 'image_list_id')
  final String? id;

  @override
  @JsonKey(name: 'service_list_id')
  final String? fkServiceListId;

  @override
  final String? imageUrl;

  @override
  final String? semanticLabel;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory ImageDto.fromJson(Map<String, dynamic> json) => _$ImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDtoToJson(this);

  @ignore
  IsarImageRegistry toIsar() {
    return IsarImageRegistry()
      ..id = id!
      ..fkServiceListId = fkServiceListId!
      ..imageUrl = imageUrl!
      ..semanticLabel = semanticLabel ?? ''
      ..createdAt = createdAt!;
  }
}