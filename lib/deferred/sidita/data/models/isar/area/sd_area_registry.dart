import 'package:isar_community/isar.dart';
import '../../../../domain/entities/area/sd_area_entity.dart';

part 'sd_area_registry.g.dart';

@collection
class IsarSdAreaRegistry {
  Id get isarId => id;

  @Index(unique: true, replace: true)
  late int id;

  String? nama;

  @Index(unique: true, replace: true, type: IndexType.value, caseSensitive: false)
  String? slug;

  double? lat;
  double? lng;

  /// Convert to domain entity.
  @ignore
  SdAreaEntity toEntity() {
    return SdAreaEntity(
      id: id,
      nama: nama,
      slug: slug,
      lat: lat,
      lng: lng,
    );
  }
}
