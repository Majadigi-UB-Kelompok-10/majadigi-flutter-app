import 'package:freezed_annotation/freezed_annotation.dart';

part 'bpd_pajak_entity.freezed.dart';

@freezed
class BpdPajakEntity with _$BpdPajakEntity {
  const BpdPajakEntity({
    required this.identitas,
    required this.rincianBiaya,
    required this.estimasi5Tahunan,
  });

  @override
  final BpdPajakIdentitasEntity identitas;

  @override
  final BpdPajakRincianBiayaEntity rincianBiaya;

  @override
  final BpdPajakEstimasi5TahunanEntity estimasi5Tahunan;
}

@freezed
class BpdPajakIdentitasEntity with _$BpdPajakIdentitasEntity {
  const BpdPajakIdentitasEntity({
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
  final String platNomor;

  @override
  final String merk;

  @override
  final String tipe;

  @override
  final String model;

  @override
  final String warna;

  @override
  final int tahunBuat;

  @override
  final String masaPajak;

  @override
  final bool statusAktif;
}

@freezed
class BpdPajakRincianBiayaEntity with _$BpdPajakRincianBiayaEntity {
  const BpdPajakRincianBiayaEntity({
    required this.pkbPokok,
    required this.opsenPkb,
    required this.swdkllj,
    required this.parkirBerlangganan,
    required this.totalPajak,
  });

  @override
  final int pkbPokok;

  @override
  final int opsenPkb;

  @override
  final int swdkllj;

  @override
  final int parkirBerlangganan;

  @override
  final int totalPajak;
}

@freezed
class BpdPajakEstimasi5TahunanEntity with _$BpdPajakEstimasi5TahunanEntity {
  const BpdPajakEstimasi5TahunanEntity({
    required this.cetakStnk,
    required this.cetakTnkb,
  });

  @override
  final int cetakStnk;

  @override
  final int cetakTnkb;
}
