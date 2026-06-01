import 'package:freezed_annotation/freezed_annotation.dart';

part 'tj_schedule_entity.freezed.dart';

/// Entity for schedule search results.
/// Includes geo coordinates resolved from the cached terminal list.
@freezed
class TjSearchEntity with _$TjSearchEntity {
  const TjSearchEntity({
    required this.id,
    this.busKode,
    this.busLayanan,
    this.departureTime,
    this.arrivalTime,
    this.durasiMenit,
    this.originTerminal,
    this.destinationTerminal,
    this.originCity,
    this.destinationCity,
    this.price,
    this.originLatitude,
    this.originLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  @override
  final int id;

  @override
  final String? busKode;

  @override
  final String? busLayanan;

  @override
  final String? departureTime;

  @override
  final String? arrivalTime;

  @override
  final double? durasiMenit;

  @override
  final String? originTerminal;

  @override
  final String? destinationTerminal;

  @override
  final String? originCity;

  @override
  final String? destinationCity;

  @override
  final double? price;

  @override
  final double? originLatitude;

  @override
  final double? originLongitude;

  @override
  final double? destinationLatitude;

  @override
  final double? destinationLongitude;
}

/// Entity for schedule detail view.
@freezed
class TjScheduleEntity with _$TjScheduleEntity {
  const TjScheduleEntity({
    required this.id,
    this.busKode,
    this.busLayanan,
    this.jamBerangkat,
    this.jamTiba,
    this.durasiMenit,
    this.terminalAsal,
    this.terminalTujuan,
    this.ruteId,
    this.stops,
    this.semuaHarga,
    this.koordinatRute,
  });

  @override
  final int id;

  @override
  final String? busKode;

  @override
  final String? busLayanan;

  @override
  final String? jamBerangkat;

  @override
  final String? jamTiba;

  @override
  final double? durasiMenit;

  @override
  final String? terminalAsal;

  @override
  final String? terminalTujuan;

  @override
  final int? ruteId;

  @override
  final List<TjStopEntity>? stops;

  @override
  final List<TjHargaEntity>? semuaHarga;

  @override
  final List<List<double>>? koordinatRute;
}

/// Sub-entity for price info within a schedule detail.
@freezed
class TjHargaEntity with _$TjHargaEntity {
  const TjHargaEntity({
    this.tipePenumpang,
    this.harga,
  });

  @override
  final String? tipePenumpang;

  @override
  final double? harga;
}

/// Sub-entity for stop info within a schedule detail.
@freezed
class TjStopEntity with _$TjStopEntity {
  const TjStopEntity({
    this.urutan,
    this.nama,
    this.kota,
    this.lat,
    this.lng,
  });

  @override
  final int? urutan;

  @override
  final String? nama;

  @override
  final String? kota;

  @override
  final double? lat;

  @override
  final double? lng;
}
