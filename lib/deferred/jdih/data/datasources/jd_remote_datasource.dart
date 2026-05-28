import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/pengumuman/pengumuman_dto.dart';
import '../models/dto/search/search_result_dto.dart';
import '../models/dto/dokumen/dokumen_dto.dart';
import '../models/dto/dokumen_detail/dokumen_detail_dto.dart';
import '../models/dto/filter/jenis_filter_dto.dart';
import '../models/dto/pagination/pagination_dto.dart';

/// Contract for JDIH's remote data source.
/// Uses the shared Dio instance from main (Public API Gateway).
abstract class JdRemoteDatasource {
  Future<List<PengumumanDto>?> fetchPengumuman();
  Future<({List<SearchResultDto> results, PaginationDto? pagination})?> fetchSearch({
    String? keyword,
    String? nomor,
    String? tahun,
    String? jenis,
    String? sort,
    int? page,
    int? limit,
  });
  Future<({List<DokumenDto> results, PaginationDto? pagination})?> fetchDokumenByJenis({
    required String jenis,
    String? keyword,
    String? tahun,
    int? page,
    int? limit,
  });
  Future<List<int>?> fetchTahunByJenis(String jenis);
  Future<DokumenDetailDto?> fetchDokumenDetail(int id);
  Future<List<int>?> fetchTahunFilters();
  Future<List<JenisFilterDto>?> fetchJenisFilters();
}

/// Implementation using Dio + Zstandard decompression.
class JdRemoteDatasourceImpl implements JdRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  JdRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/jdih/public';

  @override
  Future<List<PengumumanDto>?> fetchPengumuman() async {
    try {
      final response = await dio.get('$_basePrefix/pengumuman');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => PengumumanDto.fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<({List<SearchResultDto> results, PaginationDto? pagination})?> fetchSearch({
    String? keyword,
    String? nomor,
    String? tahun,
    String? jenis,
    String? sort,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (nomor != null) queryParams['nomor'] = nomor;
      if (tahun != null) queryParams['tahun'] = tahun;
      if (jenis != null) queryParams['jenis'] = jenis;
      if (sort != null) queryParams['sort'] = sort;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get('$_basePrefix/search', queryParameters: queryParams);
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final results = (data["data"] as List)
          .map((json) => SearchResultDto.fromJson(json))
          .toList();

      final pagination = data["pagination"] != null
          ? PaginationDto.fromJson(data["pagination"])
          : null;

      return (results: results, pagination: pagination);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<({List<DokumenDto> results, PaginationDto? pagination})?> fetchDokumenByJenis({
    required String jenis,
    String? keyword,
    String? tahun,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null) queryParams['keyword'] = keyword;
      if (tahun != null) queryParams['tahun'] = tahun;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '$_basePrefix/dokumen/$jenis',
        queryParameters: queryParams,
      );
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      final results = (data["data"] as List)
          .map((json) => DokumenDto.fromJson(json))
          .toList();

      final pagination = data["pagination"] != null
          ? PaginationDto.fromJson(data["pagination"])
          : null;

      return (results: results, pagination: pagination);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<int>?> fetchTahunByJenis(String jenis) async {
    try {
      final response = await dio.get('$_basePrefix/dokumen/$jenis/tahun');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List).cast<int>();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<DokumenDetailDto?> fetchDokumenDetail(int id) async {
    try {
      final response = await dio.get('$_basePrefix/dokumen/detail/$id');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return DokumenDetailDto.fromJson(data["data"]);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<int>?> fetchTahunFilters() async {
    try {
      final response = await dio.get('$_basePrefix/tahun');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);

      if (data["data"] == null) return null;

      return (data["data"] as List).cast<int>();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<JenisFilterDto>?> fetchJenisFilters() async {
    try {
      final response = await dio.get('$_basePrefix/jenis');
      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);
      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => JenisFilterDto.fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
