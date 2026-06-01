import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dto.freezed.dart';
part 'event_dto.g.dart';

// ---------------------------------------------------------------------------
// Base DTO — shared fields across event endpoints
// Cannot use freezed due to inheritance
// ---------------------------------------------------------------------------

/// Base for event DTOs with overlapping fields.
@JsonSerializable(explicitToJson: true)
class BaseEventDto {
  const BaseEventDto({
    required this.id,
    this.nama,
    this.slug,
    this.gambarUrlThumbnail,
  });

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "nama")
  final String? nama;

  @JsonKey(name: "slug")
  final String? slug;

  @JsonKey(name: "gambar_url_thumbnail")
  final String? gambarUrlThumbnail;

  factory BaseEventDto.fromJson(Map<String, dynamic> json) =>
      _$BaseEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseEventDtoToJson(this);
}

// ---------------------------------------------------------------------------
// List DTO — GET /sidita/public/event
// ---------------------------------------------------------------------------

/// Event list item (paginated endpoint).
@JsonSerializable(explicitToJson: true)
class EventDto extends BaseEventDto {
  const EventDto({
    required super.id,
    super.nama,
    super.slug,
    super.gambarUrlThumbnail,
    this.alamat,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.hargaTiket,
    this.tahun,
    this.bulan,
    this.areaNama,
    this.areaSlug,
  });

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "tanggal_mulai")
  final String? tanggalMulai;

  @JsonKey(name: "tanggal_selesai")
  final String? tanggalSelesai;

  @JsonKey(name: "harga_tiket")
  final int? hargaTiket;

  @JsonKey(name: "tahun")
  final int? tahun;

  @JsonKey(name: "bulan")
  final int? bulan;

  @JsonKey(name: "area_nama")
  final String? areaNama;

  @JsonKey(name: "area_slug")
  final String? areaSlug;

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Recommendation DTO — GET /sidita/public/event/recommendation
// ---------------------------------------------------------------------------

/// Event recommendation item.
@freezed
@JsonSerializable(explicitToJson: true)
class EventRecommendationDto with _$EventRecommendationDto {
  const EventRecommendationDto({
    required this.id,
    this.nama,
    this.alamat,
    this.gambarUrlThumbnail,
    this.tanggal,
    this.bulan,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "alamat")
  final String? alamat;

  @override
  @JsonKey(name: "gambar_url_thumbnail")
  final String? gambarUrlThumbnail;

  @override
  @JsonKey(name: "tanggal")
  final int? tanggal;

  @override
  @JsonKey(name: "bulan")
  final int? bulan;

  factory EventRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$EventRecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventRecommendationDtoToJson(this);
}

// ---------------------------------------------------------------------------
// Detail DTO — GET /sidita/public/event/{id}
// Note: response wraps data in {"event": {...}}
// ---------------------------------------------------------------------------

/// Event detail (nested under "event" key in API response).
@JsonSerializable(explicitToJson: true)
class EventDetailDto extends BaseEventDto {
  const EventDetailDto({
    required super.id,
    super.nama,
    super.slug,
    super.gambarUrlThumbnail,
    this.deskripsi,
    this.alamat,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.infoTiket,
    this.hargaTiket,
    this.gambarUrlHero,
    this.lat,
    this.lng,
    this.createdAt,
    this.areaId,
    this.areaNama,
    this.areaSlug,
  });

  @JsonKey(name: "deskripsi")
  final String? deskripsi;

  @JsonKey(name: "alamat")
  final String? alamat;

  @JsonKey(name: "tanggal_mulai")
  final String? tanggalMulai;

  @JsonKey(name: "tanggal_selesai")
  final String? tanggalSelesai;

  @JsonKey(name: "info_tiket")
  final String? infoTiket;

  @JsonKey(name: "harga_tiket")
  final int? hargaTiket;

  @JsonKey(name: "gambar_url_hero")
  final String? gambarUrlHero;

  @JsonKey(name: "lat")
  final double? lat;

  @JsonKey(name: "lng")
  final double? lng;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "area_id")
  final int? areaId;

  @JsonKey(name: "area_nama")
  final String? areaNama;

  @JsonKey(name: "area_slug")
  final String? areaSlug;

  factory EventDetailDto.fromJson(Map<String, dynamic> json) =>
      _$EventDetailDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventDetailDtoToJson(this);
}
