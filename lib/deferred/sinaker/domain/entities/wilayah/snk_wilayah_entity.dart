import 'package:freezed_annotation/freezed_annotation.dart';

part 'snk_wilayah_entity.freezed.dart';

/// Shared entity for all wilayah levels (provinsi, kab/kota, kecamatan, desa)
@freezed
class SnkWilayahEntity with _$SnkWilayahEntity {
  const SnkWilayahEntity({
    required this.id,
    required this.nama,
    this.latitude,
    this.longitude,
  });

  @override
  final String id;

  @override
  final String nama;

  @override
  final double? latitude;

  @override
  final double? longitude;
}
