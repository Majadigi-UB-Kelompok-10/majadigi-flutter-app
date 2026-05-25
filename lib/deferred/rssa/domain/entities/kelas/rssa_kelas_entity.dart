import 'package:freezed_annotation/freezed_annotation.dart';

part 'rssa_kelas_entity.freezed.dart';

@freezed
class RssaKelasEntity with _$RssaKelasEntity {
  const RssaKelasEntity({
    required this.id,
    required this.nama,
    required this.slug,
  });

  @override
  final int id;

  @override
  final String nama;

  @override
  final String slug;
}
