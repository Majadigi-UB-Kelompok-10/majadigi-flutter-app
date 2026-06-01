import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/core/storage.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/data/datasources/sd_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/data/datasources/sd_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/data/repositories/sd_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/repositories/sd_repository.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/usecase/sd_use_cases.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/entities/area/sd_area_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/entities/destination/sd_destination_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/entities/event/sd_event_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/entities/hotel/sd_hotel_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/domain/entities/map/sd_map_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/sidita/data/models/dto/pagination/sd_pagination_dto.dart';

part 'sd_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

/// Local Datasource — uses module's own Isar instance.
@riverpod
Future<SdLocalDatasource> _sdLocalDatasource(Ref ref) async {
  final isar = await ref.watch(sdIsarProvider.future);
  return SdLocalDatasourceImpl(isar);
}

/// Remote Datasource — uses shared Dio & Zstandard from main.
@riverpod
SdRemoteDatasource _sdRemoteDatasource(Ref ref) {
  return SdRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
Future<SdRepository> _sdRepository(Ref ref) async {
  final localDatasource = await ref.watch(_sdLocalDatasourceProvider.future);
  final remoteDatasource = ref.watch(_sdRemoteDatasourceProvider);
  return SdRepositoryImpl(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
  );
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
Future<GetAreasUseCase> _getAreasUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetAreasUseCase(repo);
}

@riverpod
Future<SearchDestinationsUseCase> _searchDestinationsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return SearchDestinationsUseCase(repo);
}

@riverpod
Future<GetDestinationDetailUseCase> _getDestinationDetailUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetDestinationDetailUseCase(repo);
}

@riverpod
Future<GetDestinationRecommendationsUseCase> _getDestinationRecommendationsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetDestinationRecommendationsUseCase(repo);
}

@riverpod
Future<GetDestinationMapUseCase> _getDestinationMapUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetDestinationMapUseCase(repo);
}

@riverpod
Future<SearchHotelsUseCase> _searchHotelsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return SearchHotelsUseCase(repo);
}

@riverpod
Future<GetHotelDetailUseCase> _getHotelDetailUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetHotelDetailUseCase(repo);
}

@riverpod
Future<GetHotelRecommendationsUseCase> _getHotelRecommendationsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetHotelRecommendationsUseCase(repo);
}

@riverpod
Future<GetHotelMapUseCase> _getHotelMapUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetHotelMapUseCase(repo);
}

@riverpod
Future<SearchEventsUseCase> _searchEventsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return SearchEventsUseCase(repo);
}

@riverpod
Future<GetEventDetailUseCase> _getEventDetailUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetEventDetailUseCase(repo);
}

@riverpod
Future<GetEventRecommendationsUseCase> _getEventRecommendationsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetEventRecommendationsUseCase(repo);
}

@riverpod
Future<GetAvailableYearsUseCase> _getAvailableYearsUseCase(Ref ref) async {
  final repo = await ref.watch(_sdRepositoryProvider.future);
  return GetAvailableYearsUseCase(repo);
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

/// Get all areas (cached).
@riverpod
Future<List<SdAreaEntity>> sdAreas(Ref ref) async {
  final useCase = await ref.watch(_getAreasUseCaseProvider.future);
  return await useCase.execute();
}

/// Search destinations with pagination.
@riverpod
Future<(List<SdDestinationEntity>, SdPaginationDto?)> sdDestinations(
  Ref ref, {
  String? search,
  String? area,
  int? page,
  int? limit,
}) async {
  final useCase = await ref.watch(_searchDestinationsUseCaseProvider.future);
  return await useCase.execute(search: search, area: area, page: page, limit: limit);
}

/// Get destination detail.
@riverpod
Future<SdDestinationDetailEntity?> sdDestinationDetail(Ref ref, {required int id}) async {
  final useCase = await ref.watch(_getDestinationDetailUseCaseProvider.future);
  return await useCase.execute(id);
}

/// Get destination recommendations (cached).
@riverpod
Future<List<SdDestinationRecommendationEntity>> sdDestinationRecommendations(Ref ref) async {
  final useCase = await ref.watch(_getDestinationRecommendationsUseCaseProvider.future);
  return await useCase.execute();
}

/// Get destination map data.
@riverpod
Future<(SdMapCenterEntity, List<SdDestinationMapPointEntity>)?> sdDestinationMap(
  Ref ref, {
  String? search,
  String? area,
}) async {
  final useCase = await ref.watch(_getDestinationMapUseCaseProvider.future);
  return await useCase.execute(search: search, area: area);
}

/// Search hotels with pagination.
@riverpod
Future<(List<SdHotelEntity>, SdPaginationDto?)> sdHotels(
  Ref ref, {
  String? search,
  String? area,
  int? page,
  int? limit,
}) async {
  final useCase = await ref.watch(_searchHotelsUseCaseProvider.future);
  return await useCase.execute(search: search, area: area, page: page, limit: limit);
}

/// Get hotel detail.
@riverpod
Future<SdHotelDetailEntity?> sdHotelDetail(Ref ref, {required int id}) async {
  final useCase = await ref.watch(_getHotelDetailUseCaseProvider.future);
  return await useCase.execute(id);
}

/// Get hotel recommendations (cached).
@riverpod
Future<List<SdHotelRecommendationEntity>> sdHotelRecommendations(Ref ref) async {
  final useCase = await ref.watch(_getHotelRecommendationsUseCaseProvider.future);
  return await useCase.execute();
}

/// Get hotel map data.
@riverpod
Future<(SdMapCenterEntity, List<SdHotelMapPointEntity>)?> sdHotelMap(
  Ref ref, {
  String? search,
  String? area,
}) async {
  final useCase = await ref.watch(_getHotelMapUseCaseProvider.future);
  return await useCase.execute(search: search, area: area);
}

/// Search events with pagination.
@riverpod
Future<(List<SdEventEntity>, SdPaginationDto?)> sdEvents(
  Ref ref, {
  String? search,
  String? area,
  int? page,
  int? limit,
  int? tahun,
  String? bulan,
}) async {
  final useCase = await ref.watch(_searchEventsUseCaseProvider.future);
  return await useCase.execute(search: search, area: area, page: page, limit: limit, tahun: tahun, bulan: bulan);
}

/// Get event detail.
@riverpod
Future<SdEventDetailEntity?> sdEventDetail(Ref ref, {required int id}) async {
  final useCase = await ref.watch(_getEventDetailUseCaseProvider.future);
  return await useCase.execute(id);
}

/// Get event recommendations (cached).
@riverpod
Future<List<SdEventRecommendationEntity>> sdEventRecommendations(Ref ref) async {
  final useCase = await ref.watch(_getEventRecommendationsUseCaseProvider.future);
  return await useCase.execute();
}

/// Get available event years (cached).
@riverpod
Future<List<int>> sdAvailableYears(Ref ref) async {
  final useCase = await ref.watch(_getAvailableYearsUseCaseProvider.future);
  return await useCase.execute();
}
