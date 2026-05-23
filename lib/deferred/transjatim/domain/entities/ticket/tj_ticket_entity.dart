import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_ticket_entity.freezed.dart';

/// Represent a Trans Jatim Ticket Entity
@freezed
class TjTicketEntity with _$TjTicketEntity {
  const TjTicketEntity({
    this.id,
    this.ruteId,
    this.terminalAsal,
    this.terminalTujuan,
    this.layanan,
    this.tipePenumpang,
    this.harga,
  });

  @override
  final int? id;

  @override
  final int? ruteId;

  @override
  final String? terminalAsal;

  @override
  final String? terminalTujuan;

  @override
  final String? layanan;

  @override
  final String? tipePenumpang;

  @override
  final double? harga;
}
