// DTOs for the Klinik Hoaks module — maps API JSON responses.
// See [ENDPOINTS.md](../ENDPOINTS.md) for the raw response shapes.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'klinik_hoaks_dto.freezed.dart';
part 'klinik_hoaks_dto.g.dart';

/// GET /klinik/public/categories
@freezed
@JsonSerializable(explicitToJson: true)
class KhCategoryDto with _$KhCategoryDto {
  const KhCategoryDto({
    this.id,
    this.name,
    this.slug,
    this.iconUrl,
  });

  @override
  @JsonKey(name: "id")
  final String? id;

  @override
  @JsonKey(name: "name")
  final String? name;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "icon_url")
  final String? iconUrl;

  factory KhCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$KhCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhCategoryDtoToJson(this);
}

/// GET /klinik/public/stats
@freezed
@JsonSerializable(explicitToJson: true)
class KhStatDto with _$KhStatDto {
  const KhStatDto({
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.iconUrl,
    this.totalNews,
  });

  @override
  @JsonKey(name: "category_id")
  final String? categoryId;

  @override
  @JsonKey(name: "category_name")
  final String? categoryName;

  @override
  @JsonKey(name: "category_slug")
  final String? categorySlug;

  @override
  @JsonKey(name: "icon_url")
  final String? iconUrl;

  @override
  @JsonKey(name: "total_news")
  final int? totalNews;

  factory KhStatDto.fromJson(Map<String, dynamic> json) =>
      _$KhStatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhStatDtoToJson(this);
}

/// GET /klinik/public/news (list item)
@freezed
@JsonSerializable(explicitToJson: true)
class KhNewsDto with _$KhNewsDto {
  const KhNewsDto({
    this.id,
    this.title,
    this.slug,
    this.imageUrl,
    this.categoryName,
    this.categorySlug,
    this.publishedAt,
  });

  @override
  @JsonKey(name: "id")
  final String? id;

  @override
  @JsonKey(name: "title")
  final String? title;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "image_url")
  final String? imageUrl;

  @override
  @JsonKey(name: "category_name")
  final String? categoryName;

  @override
  @JsonKey(name: "category_slug")
  final String? categorySlug;

  @override
  @JsonKey(name: "published_at")
  final String? publishedAt;

  factory KhNewsDto.fromJson(Map<String, dynamic> json) =>
      _$KhNewsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhNewsDtoToJson(this);
}

/// GET /klinik/public/news/{slug}
@freezed
@JsonSerializable(explicitToJson: true)
class KhNewsDetailDto with _$KhNewsDetailDto {
  const KhNewsDetailDto({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.referenceLink,
    this.imageUrl,
    this.categoryName,
    this.categorySlug,
    this.publishedAt,
  });

  @override
  @JsonKey(name: "id")
  final String? id;

  @override
  @JsonKey(name: "title")
  final String? title;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "description")
  final String? description;

  @override
  @JsonKey(name: "reference_link")
  final String? referenceLink;

  @override
  @JsonKey(name: "image_url")
  final String? imageUrl;

  @override
  @JsonKey(name: "category_name")
  final String? categoryName;

  @override
  @JsonKey(name: "category_slug")
  final String? categorySlug;

  @override
  @JsonKey(name: "published_at")
  final String? publishedAt;

  factory KhNewsDetailDto.fromJson(Map<String, dynamic> json) =>
      _$KhNewsDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhNewsDetailDtoToJson(this);
}

/// POST /klinik/public/reports — response
@freezed
@JsonSerializable(explicitToJson: true)
class KhReportResponseDto with _$KhReportResponseDto {
  const KhReportResponseDto({
    this.ticketNumber,
    this.createdAt,
  });

  @override
  @JsonKey(name: "ticket_number")
  final String? ticketNumber;

  @override
  @JsonKey(name: "created_at")
  final String? createdAt;

  factory KhReportResponseDto.fromJson(Map<String, dynamic> json) =>
      _$KhReportResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhReportResponseDtoToJson(this);
}

/// GET /klinik/public/reports/track
@freezed
@JsonSerializable(explicitToJson: true)
class KhTrackReportDto with _$KhTrackReportDto {
  const KhTrackReportDto({
    this.reportId,
    this.ticketNumber,
    this.reporterName,
    this.reportStatus,
    this.reportedAt,
  });

  @override
  @JsonKey(name: "report_id")
  final String? reportId;

  @override
  @JsonKey(name: "ticket_number")
  final String? ticketNumber;

  @override
  @JsonKey(name: "reporter_name")
  final String? reporterName;

  @override
  @JsonKey(name: "report_status")
  final String? reportStatus;

  @override
  @JsonKey(name: "reported_at")
  final String? reportedAt;

  factory KhTrackReportDto.fromJson(Map<String, dynamic> json) =>
      _$KhTrackReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KhTrackReportDtoToJson(this);
}
