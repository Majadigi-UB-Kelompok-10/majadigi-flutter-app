import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_dto.freezed.dart';
part 'area_dto.g.dart';

/// DTO for GET /sidita/public/areas
@freezed
@JsonSerializable(explicitToJson: true)
class AreaDto with _$AreaDto {
  const AreaDto({
    required this.id,
    this.nama,
    this.slug,
    this.lat,
    this.lng,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "lat")
  final double? lat;

  @override
  @JsonKey(name: "lng")
  final double? lng;

  factory AreaDto.fromJson(Map<String, dynamic> json) =>
      _$AreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AreaDtoToJson(this);
}
