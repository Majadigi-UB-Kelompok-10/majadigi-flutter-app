import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/summary/summary_dto.dart';
import '../models/dto/kelas/kelas_dto.dart';
import '../models/dto/ruangan/ruangan_dto.dart';

abstract class RssaRemoteDatasource {
  Future<SummaryDto?> fetchSummary();
  Future<List<KelasDto>?> fetchKelas();
  Future<List<RuanganDto>?> fetchRuangan({String search = '', String kelas = ''});
}

class RssaRemoteDatasourceImpl implements RssaRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  RssaRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/rssa';

  @override
  Future<SummaryDto?> fetchSummary() async {
    try {
      final response = await dio.get('$_basePrefix/public/summary');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      // Note: Endpoint returns a single object inside "data", not a list
      return SummaryDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to fetch summary: $e');
    }
  }

  @override
  Future<List<KelasDto>?> fetchKelas() async {
    try {
      final response = await dio.get('$_basePrefix/public/kelas');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List).map((json) => KelasDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch kelas: $e');
    }
  }

  @override
  Future<List<RuanganDto>?> fetchRuangan({String search = '', String kelas = ''}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search.isNotEmpty) queryParams['search'] = search;
      if (kelas.isNotEmpty) queryParams['kelas'] = kelas;

      final response = await dio.get('$_basePrefix/public/ruangan', queryParameters: queryParams);

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List).map((json) => RuanganDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch ruangan: $e');
    }
  }
}
