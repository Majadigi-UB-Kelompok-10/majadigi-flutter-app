import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';

part 'tj_ticket_registry.g.dart';

@collection
class IsarTjTicketRegistry {
  Id get isarId => id;

  late int id;

  int? ruteId;

  @Index(type: IndexType.value, caseSensitive: false)
  String? terminalAsal;

  @Index(type: IndexType.value, caseSensitive: false)
  String? terminalTujuan;

  String? layanan;

  String? tipePenumpang;

  double? harga;

  @ignore
  TjTicketEntity toEntity() {
    return TjTicketEntity(
      id: id,
      ruteId: ruteId,
      terminalAsal: terminalAsal,
      terminalTujuan: terminalTujuan,
      layanan: layanan,
      tipePenumpang: tipePenumpang,
      harga: harga,
    );
  }
}
