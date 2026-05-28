import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/klinik_hoaks/klinik_hoaks_dto.dart';

abstract class KhRemoteDatasource {
  Future<List<KhStatDto>?> fetchStats();
  Future<List<KhNewsDto>?> fetchNews({String? search, int? page, int? limit});
  Future<KhNewsDetailDto?> fetchNewsDetail(String slug);
  Future<KhReportResponseDto?> submitReport({
    required String nama,
    required String email,
    required String noHp,
    required String isiLaporan,
    String? linkBukti,
    File? gambarBukti,
  });
  Future<KhTrackReportDto?> trackReport(String ticketNumber);
}

class KhRemoteDatasourceImpl implements KhRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  KhRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/klinik';

  @override
  Future<List<KhStatDto>?> fetchStats() async {
    try {
      final response = await dio.get('$_basePrefix/public/stats');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => KhStatDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch stats: $e');
    }
  }

  @override
  Future<List<KhNewsDto>?> fetchNews({String? search, int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '$_basePrefix/public/news',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => KhNewsDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }

  @override
  Future<KhNewsDetailDto?> fetchNewsDetail(String slug) async {
    try {
      final response = await dio.get('$_basePrefix/public/news/$slug');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return KhNewsDetailDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to fetch news detail: $e');
    }
  }

  @override
  Future<KhReportResponseDto?> submitReport({
    required String nama,
    required String email,
    required String noHp,
    required String isiLaporan,
    String? linkBukti,
    File? gambarBukti,
  }) async {
    try {
      final formData = FormData.fromMap({
        'nama': nama,
        'email': email,
        'no_hp': noHp,
        'isi_laporan': isiLaporan,
        if (linkBukti != null && linkBukti.isNotEmpty) 'link_bukti': linkBukti,
        if (gambarBukti != null)
          'gambar_bukti': await MultipartFile.fromFile(
            gambarBukti.path,
            filename: gambarBukti.path.split('/').last,
          ),
      });

      final response = await dio.post(
        '$_basePrefix/public/reports',
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return KhReportResponseDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to submit report: $e');
    }
  }

  @override
  Future<KhTrackReportDto?> trackReport(String ticketNumber) async {
    try {
      final response = await dio.get(
        '$_basePrefix/public/reports/track',
        queryParameters: {'no_tiket': ticketNumber},
      );

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return KhTrackReportDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to track report: $e');
    }
  }
}
