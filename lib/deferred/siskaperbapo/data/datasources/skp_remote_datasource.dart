import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/area/area_dto.dart';
import '../models/dto/bahan_pokok/bahan_pokok_dto.dart';

abstract class SkpRemoteDatasource {
  Future<List<AreaDto>?> fetchAreas();
  Future<List<BahanPokokDto>?> fetchBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''});
  Future<DetailBahanPokokDto?> fetchDetailBahanPokok({required String slug, String tanggal = '', String area = ''});
}

class SkpRemoteDatasourceImpl implements SkpRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  SkpRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/siskaperbapo';

  @override
  Future<List<AreaDto>?> fetchAreas() async {
    try {
      final response = await dio.get('$_basePrefix/public/areas');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List).map((json) => AreaDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch areas: $e');
    }
  }

  @override
  Future<List<BahanPokokDto>?> fetchBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tanggal.isNotEmpty) queryParams['tanggal'] = tanggal;
      if (bahanPokok.isNotEmpty) queryParams['bahan_pokok'] = bahanPokok;
      if (area.isNotEmpty) queryParams['area'] = area;

      final response = await dio.get('$_basePrefix/public/bahan-pokok', queryParameters: queryParams);

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List).map((json) => BahanPokokDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch bahan pokok: $e');
    }
  }

  @override
  Future<DetailBahanPokokDto?> fetchDetailBahanPokok({required String slug, String tanggal = '', String area = ''}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tanggal.isNotEmpty) queryParams['tanggal'] = tanggal;
      if (area.isNotEmpty) queryParams['area'] = area;

      final response = await dio.get('$_basePrefix/public/bahan-pokok/$slug', queryParameters: queryParams);

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return DetailBahanPokokDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to fetch detail bahan pokok: $e');
    }
  }
}
