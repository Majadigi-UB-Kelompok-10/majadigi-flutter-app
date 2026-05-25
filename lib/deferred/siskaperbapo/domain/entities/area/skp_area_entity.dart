import 'package:freezed_annotation/freezed_annotation.dart';

part 'skp_area_entity.freezed.dart';

@freezed
class SkpAreaEntity with _$SkpAreaEntity {
  const SkpAreaEntity({
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
