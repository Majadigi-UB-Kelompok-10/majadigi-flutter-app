// Check [ENDPOINT.md](./ENDPOINT.md) on why this dto modeled like this

import 'package:freezed_annotation/freezed_annotation.dart';

part 'area_dto.freezed.dart';
part 'area_dto.g.dart';

/// Model for JSON to Area Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class AreaDto with _$AreaDto {
  const AreaDto({
    required this.id,
    this.nama,
    this.slug
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

  // Json Serializable
  factory AreaDto.fromJson(Map<String, dynamic> json) =>
      _$AreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AreaDtoToJson(this);
}
