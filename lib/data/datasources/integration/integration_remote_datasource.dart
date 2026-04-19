import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/integration/integration_dto.dart';

/// Represent the Contract for Integration Remote Datasource.
/// Uses Public API Gateway
abstract class IntegrationRemoteDatasource {
  Future<List<IntegrationDto>> fetchIntegrationFromNetwork();
}

/// Represent the Integration Remote Datasource Implementation
class IntegrationRemoteDatasourceImpl implements IntegrationRemoteDatasource {
  final Dio _dio;
  IntegrationRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<IntegrationDto>> fetchIntegrationFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/integration');
    final data = response.data as List;
    return data.map((json) => IntegrationDto.fromJson(json)).toList();
  }
}