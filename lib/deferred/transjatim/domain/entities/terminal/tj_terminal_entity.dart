import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_terminal_entity.freezed.dart';

/// Represent a Trans Jatim Terminal Entity
@freezed
class TjTerminalEntity with _$TjTerminalEntity {
  const TjTerminalEntity({
    this.id,
    this.nama,
    this.kota,
    this.slug,
    this.lat,
    this.lng,
    this.aktif,
  });

  @override
  final int? id;

  @override
  final String? nama;

  @override
  final String? kota;

  @override
  final String? slug;

  @override
  final double? lat;

  @override
  final double? lng;

  @override
  final bool? aktif;
}
