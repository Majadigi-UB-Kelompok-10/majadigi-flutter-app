import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_hotel_entity.freezed.dart';

/// Hotel list item entity.
@freezed
class SdHotelEntity with _$SdHotelEntity {
  const SdHotelEntity({
    this.id,
    this.nama,
    this.slug,
    this.bintang,
    this.hargaMulai,
    this.alamat,
    this.highlightText,
    this.gambarUrl,
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
  final int? bintang;

  @override
  final int? hargaMulai;

  @override
  final String? alamat;

  @override
  final String? highlightText;

  @override
  final String? gambarUrl;

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final String? areaNama;

  @override
  final String? areaSlug;
}

/// Hotel detail entity (used by hotel detail screen).
@freezed
class SdHotelDetailEntity with _$SdHotelDetailEntity {
  const SdHotelDetailEntity({
    this.id,
    this.nama,
    this.slug,
    this.bintang,
    this.hargaMulai,
    this.deskripsi,
    this.alamat,
    this.highlightText,
    this.gambarUrl,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
    this.areaId,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? slug;

  @override
  final int? bintang;

  @override
  final int? hargaMulai;

  @override
  final String? deskripsi;

  @override
  final String? alamat;

  @override
  final String? highlightText;

  @override
  final String? gambarUrl;

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final String? createdAt;

  @override
  final String? updatedAt;

  @override
  final int? areaId;
}

/// Hotel recommendation entity.
@freezed
class SdHotelRecommendationEntity with _$SdHotelRecommendationEntity {
  const SdHotelRecommendationEntity({
    this.id,
    this.nama,
    this.bintang,
    this.alamat,
    this.gambarUrl,
    this.areaNama,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final int? bintang;

  @override
  final String? alamat;

  @override
  final String? gambarUrl;

  @override
  final String? areaNama;
}

/// Hotel map point entity.
@freezed
class SdHotelMapPointEntity with _$SdHotelMapPointEntity {
  const SdHotelMapPointEntity({
    this.id,
    this.nama,
    this.slug,
    this.bintang,
    this.gambarUrl,
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
  final int? bintang;

  @override
  final String? gambarUrl;

  @override
  final double? lat;

  @override
  final double? lng;
}
