import 'package:isar_community/isar.dart';
import '../models/isar/area/sd_area_registry.dart';
import '../models/isar/destination/sd_destination_recommendation_registry.dart';
import '../models/isar/event/sd_event_recommendation_registry.dart';
import '../models/isar/event/sd_event_year_registry.dart';
import '../models/isar/hotel/sd_hotel_recommendation_registry.dart';

/// Contract for SIDITA's local data source.
abstract class SdLocalDatasource {
  // Areas
  Future<List<IsarSdAreaRegistry>> getCachedAreas();
  Future<void> cacheAreas(List<IsarSdAreaRegistry> items);

  // Destination Recommendations
  Future<List<IsarSdDestinationRecommendationRegistry>> getCachedDestinationRecommendations();
  Future<void> cacheDestinationRecommendations(List<IsarSdDestinationRecommendationRegistry> items);

  // Hotel Recommendations
  Future<List<IsarSdHotelRecommendationRegistry>> getCachedHotelRecommendations();
  Future<void> cacheHotelRecommendations(List<IsarSdHotelRecommendationRegistry> items);

  // Event Recommendations
  Future<List<IsarSdEventRecommendationRegistry>> getCachedEventRecommendations();
  Future<void> cacheEventRecommendations(List<IsarSdEventRecommendationRegistry> items);

  // Event Years
  Future<List<IsarSdEventYearRegistry>> getCachedEventYears();
  Future<void> cacheEventYears(List<IsarSdEventYearRegistry> items);
}

/// Implementation using Isar database.
class SdLocalDatasourceImpl implements SdLocalDatasource {
  final Isar _isar;
  SdLocalDatasourceImpl(this._isar);

  // -----------------------------------------------------------------------
  // Areas
  // -----------------------------------------------------------------------
  @override
  Future<List<IsarSdAreaRegistry>> getCachedAreas() {
    return _isar.isarSdAreaRegistrys.where().findAll();
  }

  @override
  Future<void> cacheAreas(List<IsarSdAreaRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarSdAreaRegistrys.clear();
      await _isar.isarSdAreaRegistrys.putAllById(items);
    });
  }

  // -----------------------------------------------------------------------
  // Destination Recommendations
  // -----------------------------------------------------------------------
  @override
  Future<List<IsarSdDestinationRecommendationRegistry>> getCachedDestinationRecommendations() {
    return _isar.isarSdDestinationRecommendationRegistrys.where().findAll();
  }

  @override
  Future<void> cacheDestinationRecommendations(List<IsarSdDestinationRecommendationRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarSdDestinationRecommendationRegistrys.clear();
      await _isar.isarSdDestinationRecommendationRegistrys.putAllById(items);
    });
  }

  // -----------------------------------------------------------------------
  // Hotel Recommendations
  // -----------------------------------------------------------------------
  @override
  Future<List<IsarSdHotelRecommendationRegistry>> getCachedHotelRecommendations() {
    return _isar.isarSdHotelRecommendationRegistrys.where().findAll();
  }

  @override
  Future<void> cacheHotelRecommendations(List<IsarSdHotelRecommendationRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarSdHotelRecommendationRegistrys.clear();
      await _isar.isarSdHotelRecommendationRegistrys.putAllById(items);
    });
  }

  // -----------------------------------------------------------------------
  // Event Recommendations
  // -----------------------------------------------------------------------
  @override
  Future<List<IsarSdEventRecommendationRegistry>> getCachedEventRecommendations() {
    return _isar.isarSdEventRecommendationRegistrys.where().findAll();
  }

  @override
  Future<void> cacheEventRecommendations(List<IsarSdEventRecommendationRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarSdEventRecommendationRegistrys.clear();
      await _isar.isarSdEventRecommendationRegistrys.putAllById(items);
    });
  }

  // -----------------------------------------------------------------------
  // Event Years
  // -----------------------------------------------------------------------
  @override
  Future<List<IsarSdEventYearRegistry>> getCachedEventYears() {
    return _isar.isarSdEventYearRegistrys.where().findAll();
  }

  @override
  Future<void> cacheEventYears(List<IsarSdEventYearRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarSdEventYearRegistrys.clear();
      await _isar.isarSdEventYearRegistrys.putAllByTahun(items);
    });
  }
}
