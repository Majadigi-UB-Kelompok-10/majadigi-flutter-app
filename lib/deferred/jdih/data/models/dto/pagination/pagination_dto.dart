import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_dto.freezed.dart';
part 'pagination_dto.g.dart';

/// Shared pagination DTO used across paginated JDIH endpoints.
@freezed
@JsonSerializable(explicitToJson: true)
class PaginationDto with _$PaginationDto {
  const PaginationDto({
    this.page,
    this.limit,
    this.total,
  });

  @override
  @JsonKey(name: "page")
  final int? page;

  @override
  @JsonKey(name: "limit")
  final int? limit;

  @override
  @JsonKey(name: "total")
  final int? total;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationDtoToJson(this);
}
