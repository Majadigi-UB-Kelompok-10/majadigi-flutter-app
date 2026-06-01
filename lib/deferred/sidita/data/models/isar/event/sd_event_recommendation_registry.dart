import 'package:isar_community/isar.dart';
import '../../../../domain/entities/event/sd_event_entity.dart';

part 'sd_event_recommendation_registry.g.dart';

@collection
class IsarSdEventRecommendationRegistry {
  Id get isarId => id;

  @Index(unique: true, replace: true)
  late int id;

  String? nama;
  String? alamat;
  String? gambarUrlThumbnail;
  int? tanggal;
  int? bulan;

  /// Convert to domain entity.
  @ignore
  SdEventRecommendationEntity toEntity() {
    return SdEventRecommendationEntity(
      id: id,
      nama: nama,
      alamat: alamat,
      gambarUrlThumbnail: gambarUrlThumbnail,
      tanggal: tanggal,
      bulan: bulan,
    );
  }
}
