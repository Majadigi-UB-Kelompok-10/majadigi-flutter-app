import '../entities/area/sd_area_entity.dart';
import '../entities/destination/sd_destination_entity.dart';
import '../entities/event/sd_event_entity.dart';
import '../entities/hotel/sd_hotel_entity.dart';
import '../entities/map/sd_map_entity.dart';
import '../../data/models/dto/pagination/sd_pagination_dto.dart';

/// Abstract contract for SIDITA data operations.
/// Implementation lives in data/repositories/sd_repository_impl.dart.
abstract class SdRepository {
  // -----------------------------------------------------------------------
  // Areas (cached)
  // -----------------------------------------------------------------------
  Future<List<SdAreaEntity>> getAreas();
  Future<void> syncAreas();

  // -----------------------------------------------------------------------
  // Destinations
  // -----------------------------------------------------------------------
  Future<(List<SdDestinationEntity>, SdPaginationDto?)> searchDestinations({
    String? search,
    String? area,
    int? page,
    int? limit,
  });

  Future<SdDestinationDetailEntity?> getDestinationDetail(int id);

  Future<List<SdDestinationRecommendationEntity>> getDestinationRecommendations();
  Future<void> syncDestinationRecommendations();

  Future<(SdMapCenterEntity, List<SdDestinationMapPointEntity>)?> getDestinationMap({
    String? search,
    String? area,
  });

  // -----------------------------------------------------------------------
  // Hotels
  // -----------------------------------------------------------------------
  Future<(List<SdHotelEntity>, SdPaginationDto?)> searchHotels({
    String? search,
    String? area,
    int? page,
    int? limit,
  });

  Future<SdHotelDetailEntity?> getHotelDetail(int id);

  Future<List<SdHotelRecommendationEntity>> getHotelRecommendations();
  Future<void> syncHotelRecommendations();

  Future<(SdMapCenterEntity, List<SdHotelMapPointEntity>)?> getHotelMap({
    String? search,
    String? area,
  });

  // -----------------------------------------------------------------------
  // Events
  // -----------------------------------------------------------------------
  Future<(List<SdEventEntity>, SdPaginationDto?)> searchEvents({
    String? search,
    String? area,
    int? page,
    int? limit,
    int? tahun,
    String? bulan,
  });

  Future<SdEventDetailEntity?> getEventDetail(int id);

  Future<List<SdEventRecommendationEntity>> getEventRecommendations();
  Future<void> syncEventRecommendations();

  Future<List<int>> getAvailableYears();
  Future<void> syncAvailableYears();
}
