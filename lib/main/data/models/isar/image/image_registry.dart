import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/image/image_entity.dart';

part 'image_registry.g.dart';

@collection
class IsarImageRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index()
  late String fkServiceListId;

  late String imageUrl;

  late String semanticLabel;

  late DateTime createdAt;

  @ignore
  ImageEntity toEntity() {
    return ImageEntity(
      id: id,
      fkServiceListId: fkServiceListId,
      imageUrl: imageUrl,
      semanticLabel: semanticLabel,
      createdAt: createdAt
    );
  }
}