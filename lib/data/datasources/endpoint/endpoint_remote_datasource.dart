import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/endpoint/endpoint_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Endpoint Remote Datasource.
/// Uses Public API Gateway.
abstract class EndpointRemoteDatasource {
  Future<List<EndpointDto>> fetchEndpointFromNetwork();
}

/// Represent the Endpoint Remote Datasource Implementation
class EndpointRemoteDatasourceImpl implements EndpointRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  EndpointRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<EndpointDto>> fetchEndpointFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await dio.get('/endpoint');
    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => EndpointDto.fromJson(json)).toList();
  }
}
