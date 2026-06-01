import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_area_entity.freezed.dart';

/// Represents an area (kabupaten/kota) in SIDITA.
@freezed
class SdAreaEntity with _$SdAreaEntity {
  const SdAreaEntity({
    this.id,
    this.nama,
    this.slug,
    this.lat,
    this.lng,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? slug;

  @override
  final double? lat;

  @override
  final double? lng;
}
