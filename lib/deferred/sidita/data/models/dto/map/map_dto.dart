import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_dto.freezed.dart';
part 'map_dto.g.dart';

/// Center point for map responses.
/// Note: lat/lng come as String from the API for the center object.
@freezed
@JsonSerializable(explicitToJson: true)
class MapCenterDto with _$MapCenterDto {
  const MapCenterDto({
    this.lat,
    this.lng,
    this.zoom,
  });

  @override
  @JsonKey(name: "lat")
  final String? lat;

  @override
  @JsonKey(name: "lng")
  final String? lng;

  @override
  @JsonKey(name: "zoom")
  final int? zoom;

  factory MapCenterDto.fromJson(Map<String, dynamic> json) =>
      _$MapCenterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MapCenterDtoToJson(this);
}
