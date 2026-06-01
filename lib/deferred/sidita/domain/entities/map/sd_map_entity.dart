import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_map_entity.freezed.dart';

/// Map center point entity (parsed from String lat/lng in API).
@freezed
class SdMapCenterEntity with _$SdMapCenterEntity {
  const SdMapCenterEntity({
    this.lat,
    this.lng,
    this.zoom,
  });

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final int? zoom;
}
