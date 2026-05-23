import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal_dto.freezed.dart';
part 'terminal_dto.g.dart';

/// Model for JSON to Terminal Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class TerminalDto with _$TerminalDto {
  const TerminalDto({
    required this.id,
    this.nama,
    this.kota,
    this.slug,
    this.lat,
    this.lng,
    this.aktif,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "kota")
  final String? kota;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "lat")
  final double? lat;

  @override
  @JsonKey(name: "lng")
  final double? lng;

  @override
  @JsonKey(name: "aktif")
  final bool? aktif;

  // Json Serializable
  factory TerminalDto.fromJson(Map<String, dynamic> json) =>
      _$TerminalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TerminalDtoToJson(this);
}
