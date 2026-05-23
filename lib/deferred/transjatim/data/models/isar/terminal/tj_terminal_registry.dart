import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';

part 'tj_terminal_registry.g.dart';

@collection
class IsarTjTerminalRegistry {
  Id get isarId => id;

  late int id;

  @Index(type: IndexType.value, caseSensitive: false)
  String? nama;

  String? kota;

  String? slug;

  double? lat;

  double? lng;

  bool? aktif;

  @ignore
  TjTerminalEntity toEntity() {
    return TjTerminalEntity(
      id: id,
      nama: nama,
      kota: kota,
      slug: slug,
      lat: lat,
      lng: lng,
      aktif: aktif,
    );
  }
}
