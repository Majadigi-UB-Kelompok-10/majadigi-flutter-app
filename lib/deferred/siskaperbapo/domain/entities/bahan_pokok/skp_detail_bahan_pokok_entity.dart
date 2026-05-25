import 'package:freezed_annotation/freezed_annotation.dart';

part 'skp_detail_bahan_pokok_entity.freezed.dart';

@freezed
class SkpDetailBahanPokokEntity with _$SkpDetailBahanPokokEntity {
  const SkpDetailBahanPokokEntity({
    required this.id,
    required this.komoditas,
    required this.slug,
    required this.satuan,
    required this.gambarUrl,
    required this.tren,
    required this.tanggal,
    required this.tanggalDataAktual,
    required this.areaPilihan,
    required this.hargaUtama,
    required this.grafikRiwayat,
    required this.listKabKota,
    required this.statistik,
  });

  @override
  final int id;

  @override
  final String komoditas;

  @override
  final String slug;

  @override
  final String satuan;

  @override
  final String gambarUrl;

  @override
  final String tren;

  @override
  final String tanggal;

  @override
  final String tanggalDataAktual;

  @override
  final String areaPilihan;

  @override
  final double hargaUtama;

  @override
  final List<SkpDataGrafikEntity> grafikRiwayat;

  @override
  final List<SkpDataKabKotaEntity> listKabKota;

  @override
  final SkpDataStatistikEntity statistik;
}

@freezed
class SkpDataGrafikEntity with _$SkpDataGrafikEntity {
  const SkpDataGrafikEntity({
    required this.tanggal,
    required this.rataRataHarga,
  });

  @override
  final String tanggal;

  @override
  final double rataRataHarga;
}

@freezed
class SkpDataKabKotaEntity with _$SkpDataKabKotaEntity {
  const SkpDataKabKotaEntity({
    required this.area,
    required this.areaSlug,
    required this.harga,
  });

  @override
  final String area;

  @override
  final String areaSlug;

  @override
  final double harga;
}

@freezed
class SkpDataStatistikEntity with _$SkpDataStatistikEntity {
  const SkpDataStatistikEntity({
    required this.tertinggi,
    required this.terendah,
  });

  @override
  final SkpDataKabKotaEntity tertinggi;

  @override
  final SkpDataKabKotaEntity terendah;
}
