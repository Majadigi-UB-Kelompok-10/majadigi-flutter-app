import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_dto.freezed.dart';
part 'schedule_dto.g.dart';

/// Model for Detail Schedule
/// Cannot use freezed for inheritance
@JsonSerializable(explicitToJson: true)
class DetailScheduleDto extends BaseScheduleDto {
  const DetailScheduleDto({
    required super.id,
    super.busKode,
    super.busLayanan,
    super.jamBerangkat,
    super.jamTiba,
    super.durasiMenit,
    super.terminalAsal,
    super.terminalTujuan,
    this.ruteId,
    this.stops,
    this.semuaHarga,
  });

  @override
  @JsonKey(name: "rute_id")
  final int? ruteId;

  @override
  @JsonKey(name: "stops")
  final List<String>? stops;

  @override
  @JsonKey(name: "semua_harga")
  final List<SubHargaScheduleDto>? semuaHarga;

  // Json Serializable
  factory DetailScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$DetailScheduleDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DetailScheduleDtoToJson(this);
}

/// Sub-Model for Detail Schedule
@freezed
@JsonSerializable(explicitToJson: true)
class SubHargaScheduleDto with _$SubHargaScheduleDto {
  const SubHargaScheduleDto({
    this.tipePenumpang,
    this.harga
  });

  @override
  @JsonKey(name: "tipe_penumpang")
  final String? tipePenumpang;

  @override
  @JsonKey(name: "harga")
  final double? harga;

  // Json Serializable
  factory SubHargaScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$SubHargaScheduleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubHargaScheduleDtoToJson(this);
}

/// Model for Search Schedule
/// Cannot use freezed for inheritance
@JsonSerializable(explicitToJson: true)
class SearchScheduleDto extends BaseScheduleDto {
  const SearchScheduleDto({
    required super.id,
    super.busKode,
    super.busLayanan,
    super.jamBerangkat,
    super.jamTiba,
    super.durasiMenit,
    super.terminalAsal,
    super.terminalTujuan,
    this.harga,
  });

  @override
  @JsonKey(name: "harga")
  final double? harga;

  // Json Serializable
  factory SearchScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$SearchScheduleDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchScheduleDtoToJson(this);
}

/// Model for JSON to Base Schedule Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class BaseScheduleDto with _$BaseScheduleDto {
  const BaseScheduleDto({
    required this.id,
    this.busKode,
    this.busLayanan,
    this.jamBerangkat,
    this.jamTiba,
    this.durasiMenit,
    this.terminalAsal,
    this.terminalTujuan
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
  @JsonKey(name: "jam_berangkat")
  final String? jamBerangkat;

  @override
  @JsonKey(name: "jam_tiba")
  final String? jamTiba;

  @override
  @JsonKey(name: "durasi_menit")
  final double? durasiMenit;

  @override
  @JsonKey(name: "terminal_asal")
  final String? terminalAsal;

  @override
  @JsonKey(name: "terminal_tujuan")
  final String? terminalTujuan;

  // Json Serializable
  factory BaseScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$BaseScheduleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseScheduleDtoToJson(this);
}
