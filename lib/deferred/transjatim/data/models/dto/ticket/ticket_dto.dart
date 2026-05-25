import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_dto.freezed.dart';
part 'ticket_dto.g.dart';

/// Model for JSON to Ticket Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class TicketDto with _$TicketDto {
  const TicketDto({
    this.regulerTicketList,
    this.luxuryTicketList
  });

  @override
  @JsonKey(name: "reguler")
  final List<RegulerTicketDto>? regulerTicketList;

  @override
  @JsonKey(name: "luxury")
  final List<LuxuryTicketDto>? luxuryTicketList;

  // Json Serializable
  factory TicketDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDtoToJson(this);
}

/// Model for Reguler Ticket
@freezed
@JsonSerializable(explicitToJson: true)
class RegulerTicketDto with _$RegulerTicketDto {
  const RegulerTicketDto({
    this.tipePenumpang,
    this.harga,
    this.keterangan
  });

  @override
  @JsonKey(name: "tipe_penumpang")
  final String? tipePenumpang;

  @override
  @JsonKey(name: "harga")
  final double? harga;

  @override
  @JsonKey(name: "keterangan")
  final String? keterangan;

  factory RegulerTicketDto.fromJson(Map<String, dynamic> json) =>
      _$RegulerTicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegulerTicketDtoToJson(this);
}

/// Model for Luxury Ticket
@freezed
@JsonSerializable(explicitToJson: true)
class LuxuryTicketDto with _$LuxuryTicketDto {
  const LuxuryTicketDto({
    this.ruteNama,
    this.harga,
    this.fasilitas
  });

  @override
  @JsonKey(name: "rute_nama")
  final String? ruteNama;

  @override
  @JsonKey(name: "harga")
  final double? harga;

  @override
  @JsonKey(name: "fasilitas")
  final String? fasilitas;

  factory LuxuryTicketDto.fromJson(Map<String, dynamic> json) =>
      _$LuxuryTicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LuxuryTicketDtoToJson(this);
}