import 'package:isar_community/isar.dart';
import '../../../../domain/entities/destination/sd_destination_entity.dart';

part 'sd_destination_recommendation_registry.g.dart';

@collection
class IsarSdDestinationRecommendationRegistry {
  Id get isarId => id;

  @Index(unique: true, replace: true)
  late int id;

  String? nama;
  String? gambarUrlThumbnail;
  String? alamat;
  String? areaNama;

  /// Convert to domain entity.
  @ignore
  SdDestinationRecommendationEntity toEntity() {
    return SdDestinationRecommendationEntity(
      id: id,
      nama: nama,
      gambarUrlThumbnail: gambarUrlThumbnail,
      alamat: alamat,
      areaNama: areaNama,
    );
  }
}
