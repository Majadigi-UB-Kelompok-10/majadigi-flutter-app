import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_pagination_dto.freezed.dart';
part 'sd_pagination_dto.g.dart';

/// Pagination DTO specific to SIDITA endpoints.
/// Has `total_data` and `total_pages` (differs from JDIH's pagination).
@freezed
@JsonSerializable(explicitToJson: true)
class SdPaginationDto with _$SdPaginationDto {
  const SdPaginationDto({
    this.page,
    this.limit,
    this.totalData,
    this.totalPages,
  });

  @override
  @JsonKey(name: "page")
  final int? page;

  @override
  @JsonKey(name: "limit")
  final int? limit;

  @override
  @JsonKey(name: "total_data")
  final int? totalData;

  @override
  @JsonKey(name: "total_pages")
  final int? totalPages;

  factory SdPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$SdPaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SdPaginationDtoToJson(this);
}
