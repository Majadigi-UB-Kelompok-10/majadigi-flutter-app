import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_dto.freezed.dart';
part 'schedule_dto.g.dart';

/// Model for JSON to Schedule Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class ScheduleDto with _$ScheduleDto {
  const ScheduleDto({
    required this.id,
    this.busKode,
    this.busLayanan,
    this.terminalAsal,
    this.terminalTujuan,
    this.ruteSlug,
    this.jamBerangkat,
    this.jamTiba,
    this.hariOperasi,
    this.aktif,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "bus_kode")
  final String? busKode;

  @override
  @JsonKey(name: "bus_layanan")
  final String? busLayanan;

  @override
  @JsonKey(name: "terminal_asal")
  final String? terminalAsal;

  @override
  @JsonKey(name: "terminal_tujuan")
  final String? terminalTujuan;

  @override
  @JsonKey(name: "rute_slug")
  final String? ruteSlug;

  @override
  @JsonKey(name: "jam_tiba")
  final String? jamTiba;

  @override
  @JsonKey(name: "jam_berangkat")
  final String? jamBerangkat;

  @override
  @JsonKey(name: "hari_operasi")
  final int? hariOperasi;

  @override
  @JsonKey(name: "aktif")
  final bool? aktif;

  // Json Serializable
  factory ScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDtoToJson(this);
}
