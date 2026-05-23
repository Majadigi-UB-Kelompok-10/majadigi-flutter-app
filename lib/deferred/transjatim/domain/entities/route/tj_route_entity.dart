import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_route_entity.freezed.dart';

/// Represent a Trans Jatim Route Entity
@freezed
class TjRouteEntity with _$TjRouteEntity {
  const TjRouteEntity({
    this.id,
    this.slug,
    this.terminalAsal,
    this.terminalTujuan,
    this.kotaAsal,
    this.kotaTujuan,
    this.durasiMenit,
    this.aktif,
  });

  @override
  final int? id;

  @override
  final String? slug;

  @override
  final String? terminalAsal;

  @override
  final String? terminalTujuan;

  @override
  final String? kotaAsal;

  @override
  final String? kotaTujuan;

  @override
  final double? durasiMenit;

  @override
  final bool? aktif;
}
