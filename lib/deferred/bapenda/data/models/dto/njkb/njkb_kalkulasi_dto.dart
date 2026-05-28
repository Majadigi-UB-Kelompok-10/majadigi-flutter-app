import 'package:freezed_annotation/freezed_annotation.dart';

part 'njkb_kalkulasi_dto.freezed.dart';
part 'njkb_kalkulasi_dto.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class NjkbKalkulasiDto with _$NjkbKalkulasiDto {
  const NjkbKalkulasiDto({
    required this.njkb,
    required this.estimasi,
    required this.beaBalikNama,
  });

  @override
  @JsonKey(name: 'njkb')
  final int njkb;

  @override
  @JsonKey(name: 'estimasi')
  final List<NjkbEstimasiDto> estimasi;

  @override
  @JsonKey(name: 'bea_balik_nama')
  final NjkbBeaBalikNamaDto beaBalikNama;

  factory NjkbKalkulasiDto.fromJson(Map<String, dynamic> json) =>
      _$NjkbKalkulasiDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NjkbKalkulasiDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class NjkbEstimasiDto with _$NjkbEstimasiDto {
  const NjkbEstimasiDto({
    required this.jenisPlat,
    required this.label,
    required this.pkb,
    required this.opsen,
  });

  @override
  @JsonKey(name: 'jenis_plat')
  final String jenisPlat;

  @override
  @JsonKey(name: 'label')
  final String label;

  @override
  @JsonKey(name: 'pkb')
  final int pkb;

  @override
  @JsonKey(name: 'opsen')
  final int opsen;

  factory NjkbEstimasiDto.fromJson(Map<String, dynamic> json) =>
      _$NjkbEstimasiDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NjkbEstimasiDtoToJson(this);
}

@freezed
@JsonSerializable(explicitToJson: true)
class NjkbBeaBalikNamaDto with _$NjkbBeaBalikNamaDto {
  const NjkbBeaBalikNamaDto({
    required this.bbn1,
    required this.opsenBbn1,
    required this.bbn2,
  });

  @override
  @JsonKey(name: 'bbn1')
  final int bbn1;

  @override
  @JsonKey(name: 'opsen_bbn1')
  final int opsenBbn1;

  @override
  @JsonKey(name: 'bbn2')
  final int bbn2;

  factory NjkbBeaBalikNamaDto.fromJson(Map<String, dynamic> json) =>
      _$NjkbBeaBalikNamaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NjkbBeaBalikNamaDtoToJson(this);
}
