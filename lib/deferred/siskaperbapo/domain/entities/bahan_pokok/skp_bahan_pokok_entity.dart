import 'package:freezed_annotation/freezed_annotation.dart';

part 'skp_bahan_pokok_entity.freezed.dart';

@freezed
class SkpBahanPokokEntity with _$SkpBahanPokokEntity {
  const SkpBahanPokokEntity({
    required this.id,
    required this.komoditas,
    required this.slug,
    required this.satuan,
    required this.gambarUrl,
    required this.tren,
    required this.hargaSekarang,
  });

  @override
  final int id;

  @override
  final String komoditas;

  @override
  final String slug;

  @override
  final String satuan;

  @override
  final String gambarUrl;

  @override
  final String tren;

  @override
  final double hargaSekarang;
}
