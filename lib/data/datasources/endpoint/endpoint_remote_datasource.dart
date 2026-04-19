import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/endpoint/endpoint_dto.dart';

/// Represent the Contract for Endpoint Remote Datasource.
/// Uses Public API Gateway.
abstract class EndpointRemoteDatasource {
  Future<List<EndpointDto>> fetchEndpointFromNetwork();
}

/// Represent the Endpoint Remote Datasource Implementation
class EndpointRemoteDatasourceImpl implements EndpointRemoteDatasource {
  final Dio _dio;
  EndpointRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<EndpointDto>> fetchEndpointFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/endpoint');
    final data = response.data as List;
    return data.map((json) => EndpointDto.fromJson(json)).toList();
  }
}