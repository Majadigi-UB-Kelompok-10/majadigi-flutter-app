import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/normalized_service_category/normalized_service_category_dto.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';

/// Represent the Contract for Service Remote Datasource
/// uses Public API Gateway
abstract class ServiceRemoteDatasource {
  Future<List<NormalizedServiceCategoryDto>> fetchNormalizedServicesFromNetwork();
}

/// Represent the Service Remote Datasource Implementation
class ServiceRemoteDatasourceImpl implements ServiceRemoteDatasource {
  final Dio _dio;
  ServiceRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<NormalizedServiceCategoryDto>> fetchNormalizedServicesFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    // ! This should fetch the normalized services
    final response = await _dio.get('/services');
    final data = response.data as List;
    return data.map((json) => NormalizedServiceCategoryDto.fromJson(json)).toList();
  }
}