import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_schedule_entity.freezed.dart';

/// Represent a Trans Jatim Schedule Entity
@freezed
class TjScheduleEntity with _$TjScheduleEntity {
  const TjScheduleEntity({
    this.id,
    this.busKode,
    this.busLayanan,
    this.terminalAsal,
    this.terminalTujuan,
    this.ruteSlug,
    this.jamBerangkat,
    this.jamTiba,
    this.hariOperasi,
    this.aktif,
  });

  @override
  final int? id;

  @override
  final String? busKode;

  @override
  final String? busLayanan;

  @override
  final String? terminalAsal;

  @override
  final String? terminalTujuan;

  @override
  final String? ruteSlug;

  @override
  final String? jamBerangkat;

  @override
  final String? jamTiba;

  @override
  final int? hariOperasi;

  @override
  final bool? aktif;
}
