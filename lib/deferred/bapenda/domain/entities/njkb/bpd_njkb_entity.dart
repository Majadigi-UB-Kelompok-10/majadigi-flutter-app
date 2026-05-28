import 'package:freezed_annotation/freezed_annotation.dart';

part 'bpd_njkb_entity.freezed.dart';

@freezed
class BpdNjkbKalkulasiEntity with _$BpdNjkbKalkulasiEntity {
  const BpdNjkbKalkulasiEntity({
    required this.njkb,
    required this.estimasi,
    required this.beaBalikNama,
  });

  @override
  final int njkb;

  @override
  final List<BpdNjkbEstimasiEntity> estimasi;

  @override
  final BpdNjkbBeaBalikNamaEntity beaBalikNama;
}

@freezed
class BpdNjkbEstimasiEntity with _$BpdNjkbEstimasiEntity {
  const BpdNjkbEstimasiEntity({
    required this.jenisPlat,
    required this.label,
    required this.pkb,
    required this.opsen,
  });

  @override
  final String jenisPlat;

  @override
  final String label;

  @override
  final int pkb;

  @override
  final int opsen;
}

@freezed
class BpdNjkbBeaBalikNamaEntity with _$BpdNjkbBeaBalikNamaEntity {
  const BpdNjkbBeaBalikNamaEntity({
    required this.bbn1,
    required this.opsenBbn1,
    required this.bbn2,
  });

  @override
  final int bbn1;

  @override
  final int opsenBbn1;

  @override
  final int bbn2;
}
