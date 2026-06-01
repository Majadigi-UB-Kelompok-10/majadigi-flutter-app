import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/area/area_dto.dart';
import '../models/dto/destination/destination_dto.dart';
import '../models/dto/event/event_dto.dart';
import '../models/dto/hotel/hotel_dto.dart';
import '../models/dto/map/map_dto.dart';
import '../models/dto/pagination/sd_pagination_dto.dart';

/// Contract for SIDITA's remote data source.
abstract class SdRemoteDatasource {
  // Areas
  Future<List<AreaDto>?> fetchAreas();

  // Destinations
  Future<(List<DestinationDto>, SdPaginationDto?)?> fetchDestinations({String? search, String? area, int? page, int? limit});
  Future<DestinationDetailDto?> fetchDestinationDetail(int id);
  Future<List<DestinationRecommendationDto>?> fetchDestinationRecommendations();
  Future<(MapCenterDto, List<DestinationMapPointDto>)?> fetchDestinationMap({String? search, String? area});

  // Hotels
  Future<(List<HotelDto>, SdPaginationDto?)?> fetchHotels({String? search, String? area, int? page, int? limit});
  Future<HotelDetailDto?> fetchHotelDetail(int id);
  Future<List<HotelRecommendationDto>?> fetchHotelRecommendations();
  Future<(MapCenterDto, List<HotelMapPointDto>)?> fetchHotelMap({String? search, String? area});

  // Events
  Future<(List<EventDto>, SdPaginationDto?)?> fetchEvents({String? search, String? area, int? page, int? limit, int? tahun, String? bulan});
  Future<EventDetailDto?> fetchEventDetail(int id);
  Future<List<EventRecommendationDto>?> fetchEventRecommendations();
  Future<List<int>?> fetchAvailableYears();
}

/// Implementation using shared Dio + Zstandard.
class SdRemoteDatasourceImpl implements SdRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  SdRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/sidita';

  // -----------------------------------------------------------------------
  // Areas
  // -----------------------------------------------------------------------
  @override
  Future<List<AreaDto>?> fetchAreas() async {
    try {
      final response = await dio.get('$_basePrefix/public/areas');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => AreaDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch areas: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Destinations
  // -----------------------------------------------------------------------
  @override
  Future<(List<DestinationDto>, SdPaginationDto?)?> fetchDestinations({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (area != null && area.isNotEmpty) queryParams['area'] = area;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '$_basePrefix/public/destinasi',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final items = (data["data"] as List)
          .map((json) => DestinationDto.fromJson(json))
          .toList();

      final pagination = data["pagination"] != null
          ? SdPaginationDto.fromJson(data["pagination"])
          : null;

      return (items, pagination);
    } catch (e) {
      throw Exception('Failed to fetch destinations: $e');
    }
  }

  @override
  Future<DestinationDetailDto?> fetchDestinationDetail(int id) async {
    try {
      final response = await dio.get('$_basePrefix/public/destinasi/$id');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return DestinationDetailDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to fetch destination detail: $e');
    }
  }

  @override
  Future<List<DestinationRecommendationDto>?> fetchDestinationRecommendations() async {
    try {
      final response = await dio.get('$_basePrefix/public/destinasi/recommendation');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null || data["data"]["items"] == null) return null;

      return (data["data"]["items"] as List)
          .map((json) => DestinationRecommendationDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch destination recommendations: $e');
    }
  }

  @override
  Future<(MapCenterDto, List<DestinationMapPointDto>)?> fetchDestinationMap({
    String? search,
    String? area,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (area != null && area.isNotEmpty) queryParams['area'] = area;

      final response = await dio.get(
        '$_basePrefix/public/destinasi/maps',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final center = MapCenterDto.fromJson(data["data"]["center"]);
      final points = (data["data"]["points"] as List)
          .map((json) => DestinationMapPointDto.fromJson(json))
          .toList();

      return (center, points);
    } catch (e) {
      throw Exception('Failed to fetch destination map: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Hotels
  // -----------------------------------------------------------------------
  @override
  Future<(List<HotelDto>, SdPaginationDto?)?> fetchHotels({
    String? search,
    String? area,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (area != null && area.isNotEmpty) queryParams['area'] = area;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '$_basePrefix/public/hotel',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final items = (data["data"] as List)
          .map((json) => HotelDto.fromJson(json))
          .toList();

      final pagination = data["pagination"] != null
          ? SdPaginationDto.fromJson(data["pagination"])
          : null;

      return (items, pagination);
    } catch (e) {
      throw Exception('Failed to fetch hotels: $e');
    }
  }

  @override
  Future<HotelDetailDto?> fetchHotelDetail(int id) async {
    try {
      final response = await dio.get('$_basePrefix/public/hotel/$id');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return HotelDetailDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to fetch hotel detail: $e');
    }
  }

  @override
  Future<List<HotelRecommendationDto>?> fetchHotelRecommendations() async {
    try {
      final response = await dio.get('$_basePrefix/public/hotel/recommendation');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null || data["data"]["items"] == null) return null;

      return (data["data"]["items"] as List)
          .map((json) => HotelRecommendationDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch hotel recommendations: $e');
    }
  }

  @override
  Future<(MapCenterDto, List<HotelMapPointDto>)?> fetchHotelMap({
    String? search,
    String? area,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (area != null && area.isNotEmpty) queryParams['area'] = area;

      final response = await dio.get(
        '$_basePrefix/public/hotel/maps',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final center = MapCenterDto.fromJson(data["data"]["center"]);
      final points = (data["data"]["points"] as List)
          .map((json) => HotelMapPointDto.fromJson(json))
          .toList();

      return (center, points);
    } catch (e) {
      throw Exception('Failed to fetch hotel map: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Events
  // -----------------------------------------------------------------------
  @override
  Future<(List<EventDto>, SdPaginationDto?)?> fetchEvents({
    String? search,
    String? area,
    int? page,
    int? limit,
    int? tahun,
    String? bulan,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (area != null && area.isNotEmpty) queryParams['area'] = area;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (tahun != null) queryParams['tahun'] = tahun;
      if (bulan != null && bulan.isNotEmpty) queryParams['bulan'] = bulan;

      final response = await dio.get(
        '$_basePrefix/public/event',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final items = (data["data"] as List)
          .map((json) => EventDto.fromJson(json))
          .toList();

      final pagination = data["pagination"] != null
          ? SdPaginationDto.fromJson(data["pagination"])
          : null;

      return (items, pagination);
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Future<EventDetailDto?> fetchEventDetail(int id) async {
    try {
      final response = await dio.get('$_basePrefix/public/event/$id');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      // Event detail is nested under "event" key
      if (data["data"] == null || data["data"]["event"] == null) return null;

      return EventDetailDto.fromJson(data["data"]["event"]);
    } catch (e) {
      throw Exception('Failed to fetch event detail: $e');
    }
  }

  @override
  Future<List<EventRecommendationDto>?> fetchEventRecommendations() async {
    try {
      final response = await dio.get('$_basePrefix/public/event/recommendation');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null || data["data"]["items"] == null) return null;

      return (data["data"]["items"] as List)
          .map((json) => EventRecommendationDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch event recommendations: $e');
    }
  }

  @override
  Future<List<int>?> fetchAvailableYears() async {
    try {
      final response = await dio.get('$_basePrefix/public/event/tahun-tersedia');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null || data["data"]["tahun"] == null) return null;

      return (data["data"]["tahun"] as List).cast<int>();
    } catch (e) {
      throw Exception('Failed to fetch available years: $e');
    }
  }
}
