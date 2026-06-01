// Check [ENDPOINT.md](./ENDPOINT.md) on why this dto modeled like this

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bahan_pokok_dto.freezed.dart';
part 'bahan_pokok_dto.g.dart';

/// Model for GET detail bahan pokok
/// Cannot use freezed due to inheritance
@JsonSerializable(explicitToJson: true)
class DetailBahanPokokDto extends BaseBahanPokokDto {
  const DetailBahanPokokDto({
    required super.id,
    super.komoditas,
    super.slug,
    super.satuan,
    super.gambarUrl,
    super.tren,
    this.tanggal,
    this.tanggalDataAktual,
    this.areaPilihan,
    this.hargaUtama,
    this.grafikRiwayat,
    this.listKabKota,
    this.statistik,
  });

  @override
  @JsonKey(name: "tanggal")
  final String? tanggal;

  @override
  @JsonKey(name: "tanggal_data_aktual")
  final String? tanggalDataAktual;

  @override
  @JsonKey(name: "area_pilihan")
  final String? areaPilihan;

  @override
  @JsonKey(name: "harga_utama")
  final double? hargaUtama;

  @override
  @JsonKey(name: "grafik_riwayat")
  final List<DataGrafikBahanPokokDto>? grafikRiwayat;

  @override
  @JsonKey(name: "list_kab_kota")
  final List<DataKabKotaBahanPokokDto>? listKabKota;

  @override
  @JsonKey(name: "statistik_15_hari")
  final DataStatistikBahanPokokDto? statistik;

  // Json Serializable
  factory DetailBahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$DetailBahanPokokDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DetailBahanPokokDtoToJson(this);
}

/// Model for GET bahan pokok
/// Cannot use freezed due to inheritance
@JsonSerializable(explicitToJson: true)
class BahanPokokDto extends BaseBahanPokokDto {
  const BahanPokokDto({
    required super.id,
    super.komoditas,
    super.slug,
    super.satuan,
    super.gambarUrl,
    super.tren,
    this.hargaSekarang
  });

  @override
  @JsonKey(name: "harga_sekarang")
  final double? hargaSekarang;

  // Json Serializable
  factory BahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$BahanPokokDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BahanPokokDtoToJson(this);
}

/// Sub-Models for GET detail bahan pokok
@freezed
@JsonSerializable(explicitToJson: true)
class DataGrafikBahanPokokDto with _$DataGrafikBahanPokokDto {
  const DataGrafikBahanPokokDto({
    this.tanggal,
    this.rataRataHarga
  });

  @override
  @JsonKey(name: "tanggal")
  final String? tanggal;

  @override
  @JsonKey(name: "rata_rata_harga")
  final double? rataRataHarga;

  // Json Serializable
  factory DataGrafikBahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$DataGrafikBahanPokokDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataGrafikBahanPokokDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class DataKabKotaBahanPokokDto with _$DataKabKotaBahanPokokDto {
  const DataKabKotaBahanPokokDto({
    this.area,
    this.areaSlug,
    this.harga
  });

  @override
  @JsonKey(name: "area")
  final String? area;

  @override
  @JsonKey(name: "area_slug")
  final String? areaSlug;

  @override
  @JsonKey(name: "harga")
  final double? harga;

  // Json Serializable
  factory DataKabKotaBahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$DataKabKotaBahanPokokDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataKabKotaBahanPokokDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class DataStatistikBahanPokokDto with _$DataStatistikBahanPokokDto {
  const DataStatistikBahanPokokDto({
    this.tertinggi,
    this.terendah
  });

  @override
  @JsonKey(name: "tertinggi")
  final DataKabKotaBahanPokokDto? tertinggi;

  @override
  @JsonKey(name: "terendah")
  final DataKabKotaBahanPokokDto? terendah;

  // Json Serializable
  factory DataStatistikBahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$DataStatistikBahanPokokDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataStatistikBahanPokokDtoToJson(this);
}

/// Model for JSON to BaseBahanPokok
@freezed
@JsonSerializable(explicitToJson: true)
class BaseBahanPokokDto with _$BaseBahanPokokDto {
  const BaseBahanPokokDto({
    required this.id,
    this.komoditas,
    this.slug,
    this.satuan,
    this.gambarUrl,
    this.tren
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "komoditas")
  final String? komoditas;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "satuan")
  final String? satuan;

  @override
  @JsonKey(name: "gambar_url")
  final String? gambarUrl;

  @override
  @JsonKey(name: "tren")
  final String? tren;

  // Json Serializable
  factory BaseBahanPokokDto.fromJson(Map<String, dynamic> json) =>
      _$BaseBahanPokokDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseBahanPokokDtoToJson(this);
}
