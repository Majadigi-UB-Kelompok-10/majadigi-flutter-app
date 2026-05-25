import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/terminal/terminal_dto.dart';
import '../models/dto/ticket/ticket_dto.dart';
import '../models/dto/schedule/schedule_dto.dart';

/// Contract for Trans Jatim's remote data source.
abstract class TjRemoteDatasource {
  Future<List<TerminalDto>?> fetchTerminals();
  Future<TicketDto?> fetchTickets();
  Future<List<SearchScheduleDto>?> searchSchedules({
    required int asalId,
    required int tujuanId,
    required String tanggal,
  });
  Future<DetailScheduleDto?> fetchScheduleDetail(int id);
}

/// Implementation using Dio + Zstandard decompression.
class TjRemoteDatasourceImpl implements TjRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  TjRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/transjatim';

  @override
  Future<List<TerminalDto>?> fetchTerminals() async {
    try {
      final response = await dio.get('$_basePrefix/public/terminals');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => TerminalDto.fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TicketDto?> fetchTickets() async {
    try {
      final response = await dio.get('$_basePrefix/public/harga');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return TicketDto.fromJson(data["data"]);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<SearchScheduleDto>?> searchSchedules({
    required int asalId,
    required int tujuanId,
    required String tanggal,
  }) async {
    try {
      final response = await dio.get(
        '$_basePrefix/public/jadwal/search',
        queryParameters: {
          'asal_id': asalId,
          'tujuan_id': tujuanId,
          'tanggal': tanggal,
        },
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => SearchScheduleDto.fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DetailScheduleDto?> fetchScheduleDetail(int id) async {
    try {
      final response = await dio.get('$_basePrefix/public/jadwal/$id');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return DetailScheduleDto.fromJson(data["data"]);
    } catch (e) {
      return null;
    }
  }
}
