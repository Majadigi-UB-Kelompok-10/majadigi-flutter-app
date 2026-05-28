import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_filter_dto.freezed.dart';
part 'jenis_filter_dto.g.dart';

/// DTO for items in the GET /jdih/public/jenis endpoint.
@freezed
@JsonSerializable(explicitToJson: true)
class JenisFilterDto with _$JenisFilterDto {
  const JenisFilterDto({
    required this.value,
    this.label,
  });

  @override
  @JsonKey(name: "value")
  final String value;

  @override
  @JsonKey(name: "label")
  final String? label;

  factory JenisFilterDto.fromJson(Map<String, dynamic> json) =>
      _$JenisFilterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JenisFilterDtoToJson(this);
}
