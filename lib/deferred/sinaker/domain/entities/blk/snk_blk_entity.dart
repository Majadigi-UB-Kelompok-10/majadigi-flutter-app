import 'package:freezed_annotation/freezed_annotation.dart';

part 'snk_blk_entity.freezed.dart';

@freezed
class SnkBlkEntity with _$SnkBlkEntity {
  const SnkBlkEntity({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kabKota,
    required this.kecamatan,
    required this.slug,
    this.lat,
    this.lng,
  });

  @override
  final int id;

  @override
  final String nama;

  @override
  final String alamat;

  @override
  final String kabKota;

  @override
  final String kecamatan;

  @override
  final String slug;

  @override
  final double? lat;

  @override
  final double? lng;
}
