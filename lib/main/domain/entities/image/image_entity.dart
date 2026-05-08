import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_entity.freezed.dart';

/// Represent Image Entity
@freezed
class ImageEntity with _$ImageEntity {
  const ImageEntity({
    this.id,
    this.fkServiceListId,
    this.imageUrl,
    this.semanticLabel,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? fkServiceListId;

  @override
  final String? imageUrl;

  @override
  final String? semanticLabel;

  @override
  final DateTime? createdAt;
}