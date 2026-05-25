import 'package:isar_community/isar.dart';
import '../../../../domain/entities/terminal/tj_terminal_entity.dart';

part 'tj_terminal_registry.g.dart';

@collection
class IsarTjTerminalRegistry {
  Id? id;

  String? nama;
  String? kota;
  String? slug;
  double? lat;
  double? lng;
  bool? aktif;

  TjTerminalEntity toEntity() {
    return TjTerminalEntity(
      id: id ?? 0,
      nama: nama,
      kota: kota,
      slug: slug,
      lat: lat,
      lng: lng,
      aktif: aktif,
    );
  }
}
