import 'package:freezed_annotation/freezed_annotation.dart';

part 'snk_kejuruan_entity.freezed.dart';

@freezed
class SnkKejuruanEntity with _$SnkKejuruanEntity {
  const SnkKejuruanEntity({
    required this.id,
    required this.nama,
  });

  @override
  final int id;

  @override
  final String nama;
}
