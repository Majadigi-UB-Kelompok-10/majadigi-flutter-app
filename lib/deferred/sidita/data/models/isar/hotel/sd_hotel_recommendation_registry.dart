import 'package:isar_community/isar.dart';
import '../../../../domain/entities/hotel/sd_hotel_entity.dart';

part 'sd_hotel_recommendation_registry.g.dart';

@collection
class IsarSdHotelRecommendationRegistry {
  Id get isarId => id;

  @Index(unique: true, replace: true)
  late int id;

  String? nama;
  int? bintang;
  String? alamat;
  String? gambarUrl;
  String? areaNama;

  /// Convert to domain entity.
  @ignore
  SdHotelRecommendationEntity toEntity() {
    return SdHotelRecommendationEntity(
      id: id,
      nama: nama,
      bintang: bintang,
      alamat: alamat,
      gambarUrl: gambarUrl,
      areaNama: areaNama,
    );
  }
}
