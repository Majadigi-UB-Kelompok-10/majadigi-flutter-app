import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/image/image_dto.dart';

/// Represent the Contract for Image Remote Datasource.
/// Uses Public API Gateway.
abstract class ImageRemoteDatasource {
  Future<List<ImageDto>> fetchImageFromNetwork();
}

/// Represent the Image Remote Datasource Implementation
class ImageRemoteDatasourceImpl implements ImageRemoteDatasource {
  final Dio _dio;
  ImageRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<ImageDto>> fetchImageFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/image');
    final data = response.data as List;
    return data.map((json) => ImageDto.fromJson(json)).toList();
  }
}