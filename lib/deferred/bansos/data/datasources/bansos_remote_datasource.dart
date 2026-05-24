import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/bansos_dto.dart';

abstract class BansosRemoteDatasource {
  Future<BansosDto?> fetchBansosByNik(String nik);
}

class BansosRemoteDatasourceImpl implements BansosRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  BansosRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/bansos';

  @override
  Future<BansosDto?> fetchBansosByNik(String nik) async {
    try {
      final response = await dio.get('$_basePrefix/public/cek-bansos', queryParameters: {
        'nik': nik,
      });

      if (response.statusCode != 200) return null;

      final data = await cleanupData(zstandard: zstandard, response: response);

      if (data["data"] == null) return null;

      return BansosDto.fromJson(data["data"]);
    } catch (e) {
      return null;
    }
  }
}
