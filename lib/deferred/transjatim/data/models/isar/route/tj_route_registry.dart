import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/route/tj_route_entity.dart';

part 'tj_route_registry.g.dart';

@collection
class IsarTjRouteRegistry {
  Id get isarId => id;

  late int id;

  String? slug;

  String? terminalAsal;

  String? terminalTujuan;

  String? kotaAsal;

  String? kotaTujuan;

  double? durasiMenit;

  bool? aktif;

  @ignore
  TjRouteEntity toEntity() {
    return TjRouteEntity(
      id: id,
      slug: slug,
      terminalAsal: terminalAsal,
      terminalTujuan: terminalTujuan,
      kotaAsal: kotaAsal,
      kotaTujuan: kotaTujuan,
      durasiMenit: durasiMenit,
      aktif: aktif,
    );
  }
}
