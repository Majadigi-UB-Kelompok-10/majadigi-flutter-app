import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_dto.freezed.dart';
part 'ticket_dto.g.dart';

/// Model for JSON to Ticket Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class TicketDto with _$TicketDto {
  const TicketDto({
    required this.id,
    this.ruteId,
    this.terminalAsal,
    this.terminalTujuan,
    this.layanan,
    this.tipePenumpang,
    this.harga,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "rute_id")
  final int? ruteId;

  @override
  @JsonKey(name: "terminal_asal")
  final String? terminalAsal;

  @override
  @JsonKey(name: "terminal_tujuan")
  final String? terminalTujuan;

  @override
  @JsonKey(name: "layanan")
  final String? layanan;

  @override
  @JsonKey(name: "tipe_penumpang")
  final String? tipePenumpang;

  @override
  @JsonKey(name: "harga")
  final double? harga;

  // Json Serializable
  factory TicketDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDtoToJson(this);
}
