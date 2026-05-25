import 'package:freezed_annotation/freezed_annotation.dart';

part 'rssa_ruangan_entity.freezed.dart';

@freezed
class RssaRuanganEntity with _$RssaRuanganEntity {
  const RssaRuanganEntity({
    required this.id,
    required this.nama,
    required this.slug,
    required this.kelasNama,
    required this.kelasSlug,
    required this.kapasitas,
    required this.terisi,
    required this.tersedia,
  });

  @override
  final int id;

  @override
  final String nama;

  @override
  final String slug;

  @override
  final String kelasNama;

  @override
  final String kelasSlug;

  @override
  final int kapasitas;

  @override
  final int terisi;

  @override
  final int tersedia;
}
