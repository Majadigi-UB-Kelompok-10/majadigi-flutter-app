import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_search_entity.freezed.dart';

/// Represent a Trans Jatim Search Entity
@freezed
class TjSearchEntity with _$TjSearchEntity {
  const TjSearchEntity({
    this.id,
    this.busKode,
    this.price,
    this.departureTime,
    this.arrivalTime,
    this.originCity,
    this.originTerminal,
    this.destinationCity,
    this.destinationTerminal
  });

  @override
  final int? id;

  @override
  final String? busKode;

  @override
  final double? price;

  @override
  final String? departureTime;

  @override
  final String? arrivalTime;

  @override
  final String? originCity;

  @override
  final String? destinationCity;

  @override
  final String? originTerminal;

  @override
  final String? destinationTerminal;
}
