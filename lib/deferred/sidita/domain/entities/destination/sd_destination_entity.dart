import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_destination_entity.freezed.dart';

/// Destination list item entity.
@freezed
class SdDestinationEntity with _$SdDestinationEntity {
  const SdDestinationEntity({
    this.id,
    this.nama,
    this.slug,
    this.kategori,
    this.alamat,
    this.highlightText,
    this.gambarUrlThumbnail,
    this.lat,
    this.lng,
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
  final String? kategori;

  @override
  final String? alamat;

  @override
  final String? highlightText;

  @override
  final String? gambarUrlThumbnail;

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final String? areaNama;

  @override
  final String? areaSlug;
}

/// Destination detail entity.
@freezed
class SdDestinationDetailEntity with _$SdDestinationDetailEntity {
  const SdDestinationDetailEntity({
    this.id,
    this.nama,
    this.slug,
    this.kategori,
    this.deskripsi,
    this.alamat,
    this.highlightText,
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
  final String? kategori;

  @override
  final String? deskripsi;

  @override
  final String? alamat;

  @override
  final String? highlightText;

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

/// Destination recommendation entity (used on main screen).
@freezed
class SdDestinationRecommendationEntity with _$SdDestinationRecommendationEntity {
  const SdDestinationRecommendationEntity({
    this.id,
    this.nama,
    this.gambarUrlThumbnail,
    this.alamat,
    this.areaNama,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? gambarUrlThumbnail;

  @override
  final String? alamat;

  @override
  final String? areaNama;
}

/// Destination map point entity.
@freezed
class SdDestinationMapPointEntity with _$SdDestinationMapPointEntity {
  const SdDestinationMapPointEntity({
    this.id,
    this.nama,
    this.slug,
    this.kategori,
    this.gambarUrlThumbnail,
    this.lat,
    this.lng,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? slug;

  @override
  final String? kategori;

  @override
  final String? gambarUrlThumbnail;

  @override
  final double? lat;

  @override
  final double? lng;
}
