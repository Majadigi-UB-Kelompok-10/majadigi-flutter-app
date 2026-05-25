import 'package:isar_community/isar.dart';
import '../../../../domain/entities/ticket/tj_ticket_entity.dart';

part 'tj_ticket_registry.g.dart';

@collection
class IsarTjTicketRegistry {
  Id id = Isar.autoIncrement;

  /// 'reguler' or 'luxury'
  String? layanan;

  /// Passenger type — reguler only
  String? tipePenumpang;

  double? harga;

  /// Description — reguler only
  String? keterangan;

  /// Route name — luxury only
  String? ruteNama;

  /// Facilities — luxury only
  String? fasilitas;

  TjTicketEntity toEntity() {
    return TjTicketEntity(
      layanan: layanan,
      tipePenumpang: tipePenumpang,
      harga: harga,
      keterangan: keterangan,
      ruteNama: ruteNama,
      fasilitas: fasilitas,
    );
  }
}
