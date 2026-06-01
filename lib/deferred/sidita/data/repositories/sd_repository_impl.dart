import '../datasources/sd_local_datasource.dart';
import '../datasources/sd_remote_datasource.dart';
import '../models/dto/pagination/sd_pagination_dto.dart';
import '../models/isar/area/sd_area_registry.dart';
import '../models/isar/destination/sd_destination_recommendation_registry.dart';
import '../models/isar/event/sd_event_recommendation_registry.dart';
import '../models/isar/event/sd_event_year_registry.dart';
import '../models/isar/hotel/sd_hotel_recommendation_registry.dart';
import '../../domain/entities/area/sd_area_entity.dart';
import '../../domain/entities/destination/sd_destination_entity.dart';
import '../../domain/entities/event/sd_event_entity.dart';
import '../../domain/entities/hotel/sd_hotel_entity.dart';
import '../../domain/entities/map/sd_map_entity.dart';
import '../../domain/repositories/sd_repository.dart';
import '../models/dto/area/area_dto.dart';
import '../models/dto/destination/destination_dto.dart';
import '../models/dto/event/event_dto.dart';
import '../models/dto/hotel/hotel_dto.dart';
import '../models/dto/map/map_dto.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// ---------------------------------------------------------------------------

extension AreaDtoToIsar on AreaDto {
  IsarSdAreaRegistry toIsar() {
    return IsarSdAreaRegistry()
      ..id = id
      ..nama = nama
      ..slug = slug
      ..lat = lat
      ..lng = lng;
  }
}

extension DestinationRecommendationDtoToIsar on DestinationRecommendationDto {
  IsarSdDestinationRecommendationRegistry toIsar() {
    return IsarSdDestinationRecommendationRegistry()
      ..id = id
      ..nama = nama
      ..gambarUrlThumbnail = gambarUrlThumbnail
      ..alamat = alamat
      ..areaNama = areaNama;
  }
}

extension HotelRecommendationDtoToIsar on HotelRecommendationDto {
  IsarSdHotelRecommendationRegistry toIsar() {
    return IsarSdHotelRecommendationRegistry()
      ..id = id
      ..nama = nama
      ..bintang = bintang
      ..alamat = alamat
      ..gambarUrl = gambarUrl
      ..areaNama = areaNama;
  }
}

extension EventRecommendationDtoToIsar on EventRecommendationDto {
  IsarSdEventRecommendationRegistry toIsar() {
    return IsarSdEventRecommendationRegistry()
      ..id = id
      ..nama = nama
      ..alamat = alamat
      ..gambarUrlThumbnail = gambarUrlThumbnail
      ..tanggal = tanggal
      ..bulan = bulan;
  }
}

// ---------------------------------------------------------------------------
// DTO → Entity Direct Mapping Extensions (for non-cached data)
// ---------------------------------------------------------------------------

extension DestinationDtoToEntity on DestinationDto {
  SdDestinationEntity toEntity() {
    return SdDestinationEntity(
      id: id,
      nama: nama,
      slug: slug,
      kategori: kategori,
      alamat: alamat,
      highlightText: highlightText,
      gambarUrlThumbnail: gambarUrlThumbnail,
      lat: lat,
      lng: lng,
      areaNama: areaNama,
      areaSlug: areaSlug,
    );
  }
}

extension DestinationDetailDtoToEntity on DestinationDetailDto {
  SdDestinationDetailEntity toEntity() {
    return SdDestinationDetailEntity(
      id: id,
      nama: nama,
      slug: slug,
      kategori: kategori,
      deskripsi: deskripsi,
      alamat: alamat,
      highlightText: highlightText,
      gambarUrlHero: gambarUrlHero,
      gambarUrlThumbnail: gambarUrlThumbnail,
      lat: lat,
      lng: lng,
      createdAt: createdAt,
      areaId: areaId,
      areaNama: areaNama,
      areaSlug: areaSlug,
    );
  }
}

extension DestinationMapPointDtoToEntity on DestinationMapPointDto {
  SdDestinationMapPointEntity toEntity() {
    return SdDestinationMapPointEntity(
      id: id,
      nama: nama,
      slug: slug,
      kategori: kategori,
      gambarUrlThumbnail: gambarUrlThumbnail,
      lat: lat,
      lng: lng,
    );
  }
}

extension HotelDtoToEntity on HotelDto {
  SdHotelEntity toEntity() {
    return SdHotelEntity(
      id: id,
      nama: nama,
      slug: slug,
      bintang: bintang,
      hargaMulai: hargaMulai,
      alamat: alamat,
      highlightText: highlightText,
      gambarUrl: gambarUrl,
      lat: lat,
      lng: lng,
      areaNama: areaNama,
      areaSlug: areaSlug,
    );
  }
}

extension HotelDetailDtoToEntity on HotelDetailDto {
  SdHotelDetailEntity toEntity() {
    return SdHotelDetailEntity(
      id: id,
      nama: nama,
      slug: slug,
      bintang: bintang,
      hargaMulai: hargaMulai,
      deskripsi: deskripsi,
      alamat: alamat,
      highlightText: highlightText,
      gambarUrl: gambarUrl,
      lat: lat,
      lng: lng,
      createdAt: createdAt,
      updatedAt: updatedAt,
      areaId: areaId,
    );
  }
}

extension HotelMapPointDtoToEntity on HotelMapPointDto {
  SdHotelMapPointEntity toEntity() {
    return SdHotelMapPointEntity(
      id: id,
      nama: nama,
      slug: slug,
      bintang: bintang,
      gambarUrl: gambarUrl,
      lat: lat,
      lng: lng,
    );
  }
}

extension EventDtoToEntity on EventDto {
  SdEventEntity toEntity() {
    return SdEventEntity(
      id: id,
      nama: nama,
      slug: slug,
      alamat: alamat,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      hargaTiket: hargaTiket,
      gambarUrlThumbnail: gambarUrlThumbnail,
      tahun: tahun,
      bulan: bulan,
      areaNama: areaNama,
      areaSlug: areaSlug,
    );
  }
}

extension EventDetailDtoToEntity on EventDetailDto {
  SdEventDetailEntity toEntity() {
    return SdEventDetailEntity(
      id: id,
      nama: nama,
      slug: slug,
      deskripsi: deskripsi,
      alamat: alamat,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      infoTiket: infoTiket,
      hargaTiket: hargaTiket,
      gambarUrlHero: gambarUrlHero,
      gambarUrlThumbnail: gambarUrlThumbnail,
      lat: lat,
      lng: lng,
      createdAt: createdAt,
      areaId: areaId,
      areaNama: areaNama,
      areaSlug: areaSlug,
    );
  }
}

extension MapCenterDtoToEntity on MapCenterDto {
  SdMapCenterEntity toEntity() {
    return SdMapCenterEntity(
      lat: lat != null ? double.tryParse(lat!) : null,
      lng: lng != null ? double.tryParse(lng!) : null,
      zoom: zoom,
    );
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class SdRepositoryImpl implements SdRepository {
  final SdLocalDatasource localDatasource;
  final SdRemoteDatasource remoteDatasource;

  SdRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  // -----------------------------------------------------------------------
  // Areas (SWR pattern)
  // -----------------------------------------------------------------------
  @override
  Future<List<SdAreaEntity>> getAreas() async {
    await syncAreas();
    final cached = await localDatasource.getCachedAreas();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> syncAreas() async {
    try {
      final dtos = await remoteDatasource.fetchAreas();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheAreas(registries);
    } catch (e) { /* Silently fail — cached data still available */ }
  }

  // -----------------------------------------------------------------------
  // Destinations
  // -----------------------------------------------------------------------
  @override
  Future<(List<SdDestinationEntity>, SdPaginationDto?)> searchDestinations({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) async {
    final result = await remoteDatasource.fetchDestinations(
      search: search,
      area: area,
      page: page,
      limit: limit,
    );
    if (result == null) return (<SdDestinationEntity>[], null);
    final (dtos, pagination) = result;
    return (dtos.map((d) => d.toEntity()).toList(), pagination);
  }

  @override
  Future<SdDestinationDetailEntity?> getDestinationDetail(int id) async {
    final dto = await remoteDatasource.fetchDestinationDetail(id);
    return dto?.toEntity();
  }

  @override
  Future<List<SdDestinationRecommendationEntity>> getDestinationRecommendations() async {
    await syncDestinationRecommendations();
    final cached = await localDatasource.getCachedDestinationRecommendations();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> syncDestinationRecommendations() async {
    try {
      final dtos = await remoteDatasource.fetchDestinationRecommendations();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheDestinationRecommendations(registries);
    } catch (e) { /* Silently fail */ }
  }

  @override
  Future<(SdMapCenterEntity, List<SdDestinationMapPointEntity>)?> getDestinationMap({
    String? search,
    String? area,
  }) async {
    final result = await remoteDatasource.fetchDestinationMap(search: search, area: area);
    if (result == null) return null;
    final (centerDto, pointDtos) = result;
    return (centerDto.toEntity(), pointDtos.map((d) => d.toEntity()).toList());
  }

  // -----------------------------------------------------------------------
  // Hotels
  // -----------------------------------------------------------------------
  @override
  Future<(List<SdHotelEntity>, SdPaginationDto?)> searchHotels({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) async {
    final result = await remoteDatasource.fetchHotels(
      search: search,
      area: area,
      page: page,
      limit: limit,
    );
    if (result == null) return (<SdHotelEntity>[], null);
    final (dtos, pagination) = result;
    return (dtos.map((d) => d.toEntity()).toList(), pagination);
  }

  @override
  Future<SdHotelDetailEntity?> getHotelDetail(int id) async {
    final dto = await remoteDatasource.fetchHotelDetail(id);
    return dto?.toEntity();
  }

  @override
  Future<List<SdHotelRecommendationEntity>> getHotelRecommendations() async {
    await syncHotelRecommendations();
    final cached = await localDatasource.getCachedHotelRecommendations();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> syncHotelRecommendations() async {
    try {
      final dtos = await remoteDatasource.fetchHotelRecommendations();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheHotelRecommendations(registries);
    } catch (e) { /* Silently fail */ }
  }

  @override
  Future<(SdMapCenterEntity, List<SdHotelMapPointEntity>)?> getHotelMap({
    String? search,
    String? area,
  }) async {
    final result = await remoteDatasource.fetchHotelMap(search: search, area: area);
    if (result == null) return null;
    final (centerDto, pointDtos) = result;
    return (centerDto.toEntity(), pointDtos.map((d) => d.toEntity()).toList());
  }

  // -----------------------------------------------------------------------
  // Events
  // -----------------------------------------------------------------------
  @override
  Future<(List<SdEventEntity>, SdPaginationDto?)> searchEvents({
    String? search,
    String? area,
    int? page,
    int? limit,
    int? tahun,
    String? bulan,
  }) async {
    final result = await remoteDatasource.fetchEvents(
      search: search,
      area: area,
      page: page,
      limit: limit,
      tahun: tahun,
      bulan: bulan,
    );
    if (result == null) return (<SdEventEntity>[], null);
    final (dtos, pagination) = result;
    return (dtos.map((d) => d.toEntity()).toList(), pagination);
  }

  @override
  Future<SdEventDetailEntity?> getEventDetail(int id) async {
    final dto = await remoteDatasource.fetchEventDetail(id);
    return dto?.toEntity();
  }

  @override
  Future<List<SdEventRecommendationEntity>> getEventRecommendations() async {
    await syncEventRecommendations();
    final cached = await localDatasource.getCachedEventRecommendations();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> syncEventRecommendations() async {
    try {
      final dtos = await remoteDatasource.fetchEventRecommendations();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheEventRecommendations(registries);
    } catch (e) { /* Silently fail */ }
  }

  @override
  Future<List<int>> getAvailableYears() async {
    await syncAvailableYears();
    final cached = await localDatasource.getCachedEventYears();
    return cached.map((r) => r.tahun).toList();
  }

  @override
  Future<void> syncAvailableYears() async {
    try {
      final years = await remoteDatasource.fetchAvailableYears();
      if (years == null) return;
      final registries = years.map((y) => IsarSdEventYearRegistry()..tahun = y).toList();
      await localDatasource.cacheEventYears(registries);
    } catch (e) { /* Silently fail */ }
  }
}
