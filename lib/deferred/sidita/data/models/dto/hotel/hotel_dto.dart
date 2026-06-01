import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_dto.freezed.dart';
part 'hotel_dto.g.dart';

// ---------------------------------------------------------------------------
// Base DTO — shared fields across hotel endpoints
// Cannot use freezed due to inheritance
// ---------------------------------------------------------------------------

/// Base for hotel DTOs with overlapping fields.
@JsonSerializable(explicitToJson: true)
class BaseHotelDto {
  const BaseHotelDto({
    required this.id,
    this.nama,
    this.slug,
    this.bintang,
    this.gambarUrl,
    this.lat,
    this.lng,
  });

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "nama")
  final String? nama;

  @JsonKey(name: "slug")
  final String? slug;

  @JsonKey(name: "bintang")
  final int? bintang;

  @JsonKey(name: "gambar_url")
  final String? gambarUrl;

  @JsonKey(name: "lat")
  final double? lat;

  @JsonKey(name: "lng")
  final double? lng;

  factory BaseHotelDto.fromJson(Map<String, dynamic> json) =>
      _$BaseHotelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseHotelDtoToJson(this);
}

// ---------------------------------------------------------------------------
// List DTO — GET /sidita/public/hotel
// ---------------------------------------------------------------------------

/// Hotel list item (paginated endpoint).
@JsonSerializable(explicitToJson: true)
class HotelDto extends BaseHotelDto {
  const HotelDto({
    required super.id,
    super.nama,
    super.slug,
    super.bintang,
    super.gambarUrl,
    super.lat,
    super.lng,
    this.hargaMulai,
    this.alamat,
    this.highlightText,
    this.areaNama,
    this.areaSlug,
  });

  @JsonKey(name: "harga_mulai")
  final int? hargaMulai;

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "highlight_text")
  final String? highlightText;

  @JsonKey(name: "area_nama")
  final String? areaNama;

  @JsonKey(name: "area_slug")
  final String? areaSlug;

  factory HotelDto.fromJson(Map<String, dynamic> json) =>
      _$HotelDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotelDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Map Point DTO — GET /sidita/public/hotel/maps (points array)
// ---------------------------------------------------------------------------

/// Hotel map point.
@JsonSerializable(explicitToJson: true)
class HotelMapPointDto extends BaseHotelDto {
  const HotelMapPointDto({
    required super.id,
    super.nama,
    super.slug,
    super.bintang,
    super.gambarUrl,
    super.lat,
    super.lng,
  });

  factory HotelMapPointDto.fromJson(Map<String, dynamic> json) =>
      _$HotelMapPointDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotelMapPointDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Recommendation DTO — GET /sidita/public/hotel/recommendation
// ---------------------------------------------------------------------------

/// Hotel recommendation item.
@freezed
@JsonSerializable(explicitToJson: true)
class HotelRecommendationDto with _$HotelRecommendationDto {
  const HotelRecommendationDto({
    required this.id,
    this.nama,
    this.bintang,
    this.alamat,
    this.gambarUrl,
    this.areaNama,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "bintang")
  final int? bintang;

  @override
  @JsonKey(name: "alamat")
  final String? alamat;

  @override
  @JsonKey(name: "gambar_url")
  final String? gambarUrl;

  @override
  @JsonKey(name: "area_nama")
  final String? areaNama;

  factory HotelRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$HotelRecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HotelRecommendationDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Detail DTO — GET /sidita/public/hotel/{id}
// ---------------------------------------------------------------------------

/// Hotel detail.
@JsonSerializable(explicitToJson: true)
class HotelDetailDto extends BaseHotelDto {
  const HotelDetailDto({
    required super.id,
    super.nama,
    super.slug,
    super.bintang,
    super.gambarUrl,
    super.lat,
    super.lng,
    this.hargaMulai,
    this.deskripsi,
    this.alamat,
    this.highlightText,
    this.createdAt,
    this.updatedAt,
    this.areaId,
  });

  @JsonKey(name: "harga_mulai")
  final int? hargaMulai;

  @JsonKey(name: "deskripsi")
  final String? deskripsi;

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "highlight_text")
  final String? highlightText;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(name: "area_id")
  final int? areaId;

  factory HotelDetailDto.fromJson(Map<String, dynamic> json) =>
      _$HotelDetailDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotelDetailDtoToJson(this);
}
