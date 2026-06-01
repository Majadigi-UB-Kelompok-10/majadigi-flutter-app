import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_event_entity.freezed.dart';

/// Event list item entity.
@freezed
class SdEventEntity with _$SdEventEntity {
  const SdEventEntity({
    this.id,
    this.nama,
    this.slug,
    this.alamat,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.hargaTiket,
    this.gambarUrlThumbnail,
    this.tahun,
    this.bulan,
    this.areaNama,
    this.areaSlug,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? slug;

  @override
  final String? alamat;

  @override
  final String? tanggalMulai;

  @override
  final String? tanggalSelesai;

  @override
  final int? hargaTiket;

  @override
  final String? gambarUrlThumbnail;

  @override
  final int? tahun;

  @override
  final int? bulan;

  @override
  final String? areaNama;

  @override
  final String? areaSlug;
}

/// Event detail entity.
@freezed
class SdEventDetailEntity with _$SdEventDetailEntity {
  const SdEventDetailEntity({
    this.id,
    this.nama,
    this.slug,
    this.deskripsi,
    this.alamat,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.infoTiket,
    this.hargaTiket,
    this.gambarUrlHero,
    this.gambarUrlThumbnail,
    this.lat,
    this.lng,
    this.createdAt,
    this.areaId,
    this.areaNama,
    this.areaSlug,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? slug;

  @override
  final String? deskripsi;

  @override
  final String? alamat;

  @override
  final String? tanggalMulai;

  @override
  final String? tanggalSelesai;

  @override
  final String? infoTiket;

  @override
  final int? hargaTiket;

  @override
  final String? gambarUrlHero;

  @override
  final String? gambarUrlThumbnail;

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final String? createdAt;

  @override
  final int? areaId;

  @override
  final String? areaNama;

  @override
  final String? areaSlug;
}

/// Event recommendation entity.
@freezed
class SdEventRecommendationEntity with _$SdEventRecommendationEntity {
  const SdEventRecommendationEntity({
    this.id,
    this.nama,
    this.alamat,
    this.gambarUrlThumbnail,
    this.tanggal,
    this.bulan,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? alamat;

  @override
  final String? gambarUrlThumbnail;

  @override
  final int? tanggal;

  @override
  final int? bulan;
}
