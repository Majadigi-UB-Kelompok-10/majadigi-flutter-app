import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_dto.freezed.dart';
part 'route_dto.g.dart';

/// Model for JSON to Route Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class RouteDto with _$RouteDto {
  const RouteDto({
    required this.id,
    this.slug,
    this.terminalAsal,
    this.terminalTujuan,
    this.kotaAsal,
    this.kotaTujuan,
    this.durasiMenit,
    this.aktif,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "terminal_asal")
  final String? terminalAsal;

  @override
  @JsonKey(name: "terminal_tujuan")
  final String? terminalTujuan;

  @override
  @JsonKey(name: "kota_asal")
  final String? kotaAsal;

  @override
  @JsonKey(name: "kota_tujuan")
  final String? kotaTujuan;

  @override
  @JsonKey(name: "durasi_menit")
  final double? durasiMenit;

  @override
  @JsonKey(name: "aktif")
  final bool? aktif;

  // Json Serializable
  factory RouteDto.fromJson(Map<String, dynamic> json) =>
      _$RouteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RouteDtoToJson(this);
}
