import 'package:freezed_annotation/freezed_annotation.dart';

part 'kejuruan_dto.freezed.dart';
part 'kejuruan_dto.g.dart';

/// Model for GET kejuruan list response
@freezed
@JsonSerializable(explicitToJson: true)
class KejuruanDto with _$KejuruanDto {
  const KejuruanDto({
    required this.id,
    this.nama,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  // Json Serializable
  factory KejuruanDto.fromJson(Map<String, dynamic> json) =>
      _$KejuruanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KejuruanDtoToJson(this);
}
