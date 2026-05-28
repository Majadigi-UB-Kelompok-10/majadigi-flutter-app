import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_dto.freezed.dart';
part 'search_result_dto.g.dart';

/// DTO for items in the GET /jdih/public/search endpoint.
@freezed
@JsonSerializable(explicitToJson: true)
class SearchResultDto with _$SearchResultDto {
  const SearchResultDto({
    required this.id,
    this.jenis,
    this.judul,
    this.ringkasan,
    this.tanggal,
    this.status,
    this.jumlahView,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "jenis")
  final String? jenis;

  @override
  @JsonKey(name: "judul")
  final String? judul;

  @override
  @JsonKey(name: "ringkasan")
  final String? ringkasan;

  @override
  @JsonKey(name: "tanggal")
  final String? tanggal;

  @override
  @JsonKey(name: "status")
  final String? status;

  @override
  @JsonKey(name: "jumlah_view")
  final int? jumlahView;

  factory SearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$SearchResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultDtoToJson(this);
}
