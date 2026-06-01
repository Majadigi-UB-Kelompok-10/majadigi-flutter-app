import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_dto.freezed.dart';
part 'destination_dto.g.dart';

// ---------------------------------------------------------------------------
// Base DTO — shared fields across destination endpoints
// Cannot use freezed due to inheritance
// ---------------------------------------------------------------------------

/// Base for destination DTOs with overlapping fields.
@JsonSerializable(explicitToJson: true)
class BaseDestinationDto {
  const BaseDestinationDto({
    required this.id,
    this.nama,
    this.slug,
    this.kategori,
    this.gambarUrlThumbnail,
    this.lat,
    this.lng,
  });

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "nama")
  final String? nama;

  @JsonKey(name: "slug")
  final String? slug;

  @JsonKey(name: "kategori")
  final String? kategori;

  @JsonKey(name: "gambar_url_thumbnail")
  final String? gambarUrlThumbnail;

  @JsonKey(name: "lat")
  final double? lat;

  @JsonKey(name: "lng")
  final double? lng;

  factory BaseDestinationDto.fromJson(Map<String, dynamic> json) =>
      _$BaseDestinationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseDestinationDtoToJson(this);
}

// ---------------------------------------------------------------------------
// List DTO — GET /sidita/public/destinasi
// ---------------------------------------------------------------------------

/// Destination list item (paginated endpoint).
@JsonSerializable(explicitToJson: true)
class DestinationDto extends BaseDestinationDto {
  const DestinationDto({
    required super.id,
    super.nama,
    super.slug,
    super.kategori,
    super.gambarUrlThumbnail,
    super.lat,
    super.lng,
    this.alamat,
    this.highlightText,
    this.areaNama,
    this.areaSlug,
  });

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "highlight_text")
  final String? highlightText;

  @JsonKey(name: "area_nama")
  final String? areaNama;

  @JsonKey(name: "area_slug")
  final String? areaSlug;

  factory DestinationDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DestinationDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Map Point DTO — GET /sidita/public/destinasi/maps (points array)
// ---------------------------------------------------------------------------

/// Destination map point — inherits base (has all fields needed).
@JsonSerializable(explicitToJson: true)
class DestinationMapPointDto extends BaseDestinationDto {
  const DestinationMapPointDto({
    required super.id,
    super.nama,
    super.slug,
    super.kategori,
    super.gambarUrlThumbnail,
    super.lat,
    super.lng,
  });

  factory DestinationMapPointDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationMapPointDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DestinationMapPointDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Recommendation DTO — GET /sidita/public/destinasi/recommendation
// ---------------------------------------------------------------------------

/// Destination recommendation item (different field set from list).
@freezed
@JsonSerializable(explicitToJson: true)
class DestinationRecommendationDto with _$DestinationRecommendationDto {
  const DestinationRecommendationDto({
    required this.id,
    this.nama,
    this.gambarUrlThumbnail,
    this.alamat,
    this.areaNama,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "gambar_url_thumbnail")
  final String? gambarUrlThumbnail;

  @override
  @JsonKey(name: "alamat")
  final String? alamat;

  @override
  @JsonKey(name: "area_nama")
  final String? areaNama;

  factory DestinationRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationRecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationRecommendationDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Detail DTO — GET /sidita/public/destinasi/{id}
// ---------------------------------------------------------------------------

/// Destination detail — extends base with extra fields.
@JsonSerializable(explicitToJson: true)
class DestinationDetailDto extends BaseDestinationDto {
  const DestinationDetailDto({
    required super.id,
    super.nama,
    super.slug,
    super.kategori,
    super.gambarUrlThumbnail,
    super.lat,
    super.lng,
    this.deskripsi,
    this.alamat,
    this.highlightText,
    this.gambarUrlHero,
    this.createdAt,
    this.areaId,
    this.areaNama,
    this.areaSlug,
  });

  @JsonKey(name: "deskripsi")
  final String? deskripsi;

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "highlight_text")
  final String? highlightText;

  @JsonKey(name: "gambar_url_hero")
  final String? gambarUrlHero;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "area_id")
  final int? areaId;

  @JsonKey(name: "area_nama")
  final String? areaNama;

  @JsonKey(name: "area_slug")
  final String? areaSlug;

  factory DestinationDetailDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationDetailDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DestinationDetailDtoToJson(this);
}
