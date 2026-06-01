import '../entities/area/sd_area_entity.dart';
import '../entities/destination/sd_destination_entity.dart';
import '../entities/event/sd_event_entity.dart';
import '../entities/hotel/sd_hotel_entity.dart';
import '../entities/map/sd_map_entity.dart';
import '../repositories/sd_repository.dart';
import '../../data/models/dto/pagination/sd_pagination_dto.dart';

// ---------------------------------------------------------------------------
// Areas
// ---------------------------------------------------------------------------

class GetAreasUseCase {
  final SdRepository repository;
  GetAreasUseCase(this.repository);

  Future<List<SdAreaEntity>> execute() => repository.getAreas();
}

class SyncAreasUseCase {
  final SdRepository repository;
  SyncAreasUseCase(this.repository);

  Future<void> execute() => repository.syncAreas();
}

// ---------------------------------------------------------------------------
// Destinations
// ---------------------------------------------------------------------------

class SearchDestinationsUseCase {
  final SdRepository repository;
  SearchDestinationsUseCase(this.repository);

  Future<(List<SdDestinationEntity>, SdPaginationDto?)> execute({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) => repository.searchDestinations(search: search, area: area, page: page, limit: limit);
}

class GetDestinationDetailUseCase {
  final SdRepository repository;
  GetDestinationDetailUseCase(this.repository);

  Future<SdDestinationDetailEntity?> execute(int id) => repository.getDestinationDetail(id);
}

class GetDestinationRecommendationsUseCase {
  final SdRepository repository;
  GetDestinationRecommendationsUseCase(this.repository);

  Future<List<SdDestinationRecommendationEntity>> execute() => repository.getDestinationRecommendations();
}

class SyncDestinationRecommendationsUseCase {
  final SdRepository repository;
  SyncDestinationRecommendationsUseCase(this.repository);

  Future<void> execute() => repository.syncDestinationRecommendations();
}

class GetDestinationMapUseCase {
  final SdRepository repository;
  GetDestinationMapUseCase(this.repository);

  Future<(SdMapCenterEntity, List<SdDestinationMapPointEntity>)?> execute({
    String? search,
    String? area,
  }) => repository.getDestinationMap(search: search, area: area);
}

// ---------------------------------------------------------------------------
// Hotels
// ---------------------------------------------------------------------------

class SearchHotelsUseCase {
  final SdRepository repository;
  SearchHotelsUseCase(this.repository);

  Future<(List<SdHotelEntity>, SdPaginationDto?)> execute({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) => repository.searchHotels(search: search, area: area, page: page, limit: limit);
}

class GetHotelDetailUseCase {
  final SdRepository repository;
  GetHotelDetailUseCase(this.repository);

  Future<SdHotelDetailEntity?> execute(int id) => repository.getHotelDetail(id);
}

class GetHotelRecommendationsUseCase {
  final SdRepository repository;
  GetHotelRecommendationsUseCase(this.repository);

  Future<List<SdHotelRecommendationEntity>> execute() => repository.getHotelRecommendations();
}

class SyncHotelRecommendationsUseCase {
  final SdRepository repository;
  SyncHotelRecommendationsUseCase(this.repository);

  Future<void> execute() => repository.syncHotelRecommendations();
}

class GetHotelMapUseCase {
  final SdRepository repository;
  GetHotelMapUseCase(this.repository);

  Future<(SdMapCenterEntity, List<SdHotelMapPointEntity>)?> execute({
    String? search,
    String? area,
  }) => repository.getHotelMap(search: search, area: area);
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

class SearchEventsUseCase {
  final SdRepository repository;
  SearchEventsUseCase(this.repository);

  Future<(List<SdEventEntity>, SdPaginationDto?)> execute({
    String? search,
    String? area,
    int? page,
    int? limit,
    int? tahun,
    String? bulan,
  }) => repository.searchEvents(search: search, area: area, page: page, limit: limit, tahun: tahun, bulan: bulan);
}

class GetEventDetailUseCase {
  final SdRepository repository;
  GetEventDetailUseCase(this.repository);

  Future<SdEventDetailEntity?> execute(int id) => repository.getEventDetail(id);
}

class GetEventRecommendationsUseCase {
  final SdRepository repository;
  GetEventRecommendationsUseCase(this.repository);

  Future<List<SdEventRecommendationEntity>> execute() => repository.getEventRecommendations();
}

class SyncEventRecommendationsUseCase {
  final SdRepository repository;
  SyncEventRecommendationsUseCase(this.repository);

  Future<void> execute() => repository.syncEventRecommendations();
}

class GetAvailableYearsUseCase {
  final SdRepository repository;
  GetAvailableYearsUseCase(this.repository);

  Future<List<int>> execute() => repository.getAvailableYears();
}

class SyncAvailableYearsUseCase {
  final SdRepository repository;
  SyncAvailableYearsUseCase(this.repository);

  Future<void> execute() => repository.syncAvailableYears();
}
