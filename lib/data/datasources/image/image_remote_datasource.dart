import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/image/image_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Image Remote Datasource.
/// Uses Public API Gateway.
abstract class ImageRemoteDatasource {
  Future<List<ImageDto>?> fetchImageFromNetwork();
}

/// Represent the Image Remote Datasource Implementation
class ImageRemoteDatasourceImpl implements ImageRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  ImageRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<ImageDto>?> fetchImageFromNetwork() async {
    final response = await dio.get('/images');

    if (response.statusCode == 304) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => ImageDto.fromJson(json)).toList();
  }
}
