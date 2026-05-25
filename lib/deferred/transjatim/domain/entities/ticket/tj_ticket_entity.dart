import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_ticket_entity.freezed.dart';

/// Unified ticket entity for both reguler and luxury services.
/// The [layanan] field discriminates between 'reguler' and 'luxury'.
@freezed
class TjTicketEntity with _$TjTicketEntity {
  const TjTicketEntity({
    this.layanan,
    this.tipePenumpang,
    this.harga,
    this.keterangan,
    this.ruteNama,
    this.fasilitas,
  });

  /// 'reguler' or 'luxury'
  @override
  final String? layanan;

  /// Passenger type (e.g. 'umum', 'pelajar_santri', 'mahasiswa') — reguler only
  @override
  final String? tipePenumpang;

  /// Ticket price
  @override
  final double? harga;

  /// Description — reguler only
  @override
  final String? keterangan;

  /// Route name (e.g. 'Malang - Batu') — luxury only
  @override
  final String? ruteNama;

  /// Facilities — luxury only
  @override
  final String? fasilitas;
}
