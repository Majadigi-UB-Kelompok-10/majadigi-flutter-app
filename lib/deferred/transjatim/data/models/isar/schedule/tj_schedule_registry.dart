import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';

part 'tj_schedule_registry.g.dart';

@collection
class IsarTjScheduleRegistry {
  Id get isarId => id;

  late int id;

  String? busKode;

  String? busLayanan;

  @Index(type: IndexType.value, caseSensitive: false)
  String? terminalAsal;

  @Index(type: IndexType.value, caseSensitive: false)
  String? terminalTujuan;

  String? ruteSlug;

  String? jamBerangkat;

  String? jamTiba;

  int? hariOperasi;

  bool? aktif;

  @ignore
  TjScheduleEntity toEntity() {
    return TjScheduleEntity(
      id: id,
      busKode: busKode,
      busLayanan: busLayanan,
      terminalAsal: terminalAsal,
      terminalTujuan: terminalTujuan,
      ruteSlug: ruteSlug,
      jamBerangkat: jamBerangkat,
      jamTiba: jamTiba,
      hariOperasi: hariOperasi,
      aktif: aktif,
    );
  }
}
