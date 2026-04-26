import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/image/image_registry.dart';

part 'image_dto.freezed.dart';
part 'image_dto.g.dart';

/// Model for JSON to Image Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class ImageDto with _$ImageDto {
  const ImageDto({
    this.id,
    this.fkServiceListId,
    this.imageUrl,
    this.semanticLabel,
    this.createdAt,
  });

  @override
  @JsonKey(name: 'ImageListID')
  final String? id;

  @override
  @JsonKey(name: 'ServiceListID')
  final String? fkServiceListId;

  @override
  @JsonKey(name: 'ImageUrl')
  final String? imageUrl;

  @override
  @JsonKey(name: 'SemanticLabel')
  final String? semanticLabel;

  @override
  @JsonKey(name: 'CreatedAt')
  final DateTime? createdAt;

  // Json Serializable
  factory ImageDto.fromJson(Map<String, dynamic> json) =>
      _$ImageDtoFromJson(json);

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
