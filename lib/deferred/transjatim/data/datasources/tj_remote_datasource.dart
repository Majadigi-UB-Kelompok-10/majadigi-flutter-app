import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/route/route_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/schedule/schedule_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/terminal/terminal_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/data/models/dto/ticket/ticket_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Trans Jatim Remote Datasource.
/// Uses Public API Gateway (shared Dio instance from main).
abstract class TjRemoteDatasource {
  Future<List<RouteDto>?> fetchRoutes();
  Future<List<ScheduleDto>?> fetchSchedules();
  Future<List<TerminalDto>?> fetchTerminals();
  Future<List<TicketDto>?> fetchTickets();
  Future<List<ScheduleDto>?> searchSchedules({
    required String origin,
    required String destination,
    required String date,
  });
  Future<ScheduleDto?> fetchScheduleDetail(int scheduleId);
}

/// Represent the Trans Jatim Remote Datasource Implementation
class TjRemoteDatasourceImpl implements TjRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  TjRemoteDatasourceImpl({required this.dio, this.zstandard});

  // TODO: Replace placeholder endpoints with actual Trans Jatim API endpoints
  static const String _basePrefix = '/transjatim';

  @override
  Future<List<RouteDto>?> fetchRoutes() async {
    final response = await dio.get('$_basePrefix/admin/rute');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => RouteDto.fromJson(json))
        .toList();
  }

  @override
  Future<List<ScheduleDto>?> fetchSchedules() async {
    final response = await dio.get('$_basePrefix/admin/jadwal');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => ScheduleDto.fromJson(json))
        .toList();
  }

  @override
  Future<List<TerminalDto>?> fetchTerminals() async {
    final response = await dio.get('$_basePrefix/public/terminals');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => TerminalDto.fromJson(json))
        .toList();
  }

  @override
  Future<List<TicketDto>?> fetchTickets() async {
    final response = await dio.get('$_basePrefix/admin/harga');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => TicketDto.fromJson(json))
        .toList();
  }

  @override
  Future<List<ScheduleDto>?> searchSchedules({
    required String origin,
    required String destination,
    required String date,
  }) async {
    final response = await dio.get(
      '$_basePrefix/public/jadwal/search',
      queryParameters: {
        'asal_id': origin,
        'tujuan_id': destination,
        'tanggal': date,
      },
    );

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => ScheduleDto.fromJson(json))
        .toList();
  }

  @override
  Future<ScheduleDto?> fetchScheduleDetail(int scheduleId) async {
    final response = await dio.get('$_basePrefix/public/jadwal/$scheduleId');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return ScheduleDto.fromJson(data["data"] as Map<String, dynamic>);
  }
}
