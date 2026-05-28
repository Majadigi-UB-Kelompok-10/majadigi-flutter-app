import 'package:freezed_annotation/freezed_annotation.dart';

part 'pajak_info_dto.freezed.dart';
part 'pajak_info_dto.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class PajakInfoDto with _$PajakInfoDto {
  const PajakInfoDto({
    required this.identitas,
    required this.rincianBiaya,
    required this.estimasi5Tahunan,
  });

  @override
  @JsonKey(name: 'identitas')
  final PajakIdentitasDto identitas;

  @override
  @JsonKey(name: 'rincian_biaya')
  final PajakRincianBiayaDto rincianBiaya;

  @override
  @JsonKey(name: 'estimasi_5_tahunan')
  final PajakEstimasi5TahunanDto estimasi5Tahunan;

  factory PajakInfoDto.fromJson(Map<String, dynamic> json) =>
      _$PajakInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PajakInfoDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class PajakIdentitasDto with _$PajakIdentitasDto {
  const PajakIdentitasDto({
    required this.platNomor,
    required this.merk,
    required this.tipe,
    required this.model,
    required this.warna,
    required this.tahunBuat,
    required this.masaPajak,
    required this.statusAktif,
  });

  @override
  @JsonKey(name: 'plat_nomor')
  final String platNomor;

  @override
  @JsonKey(name: 'merk')
  final String merk;

  @override
  @JsonKey(name: 'tipe')
  final String tipe;

  @override
  @JsonKey(name: 'model')
  final String model;

  @override
  @JsonKey(name: 'warna')
  final String warna;

  @override
  @JsonKey(name: 'tahun_buat')
  final int tahunBuat;

  @override
  @JsonKey(name: 'masa_pajak')
  final String masaPajak;

  @override
  @JsonKey(name: 'status_aktif')
  final bool statusAktif;

  factory PajakIdentitasDto.fromJson(Map<String, dynamic> json) =>
      _$PajakIdentitasDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PajakIdentitasDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class PajakRincianBiayaDto with _$PajakRincianBiayaDto {
  const PajakRincianBiayaDto({
    required this.pkbPokok,
    required this.opsenPkb,
    required this.swdkllj,
    required this.parkirBerlangganan,
    required this.totalPajak,
  });

  @override
  @JsonKey(name: 'pkb_pokok')
  final int pkbPokok;

  @override
  @JsonKey(name: 'opsen_pkb')
  final int opsenPkb;

  @override
  @JsonKey(name: 'swdkllj')
  final int swdkllj;

  @override
  @JsonKey(name: 'parkir_berlangganan')
  final int parkirBerlangganan;

  @override
  @JsonKey(name: 'total_pajak')
  final int totalPajak;

  factory PajakRincianBiayaDto.fromJson(Map<String, dynamic> json) =>
      _$PajakRincianBiayaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PajakRincianBiayaDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class PajakEstimasi5TahunanDto with _$PajakEstimasi5TahunanDto {
  const PajakEstimasi5TahunanDto({
    required this.cetakStnk,
    required this.cetakTnkb,
  });

  @override
  @JsonKey(name: 'cetak_stnk')
  final int cetakStnk;

  @override
  @JsonKey(name: 'cetak_tnkb')
  final int cetakTnkb;

  factory PajakEstimasi5TahunanDto.fromJson(Map<String, dynamic> json) =>
      _$PajakEstimasi5TahunanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PajakEstimasi5TahunanDtoToJson(this);
}
