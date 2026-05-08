import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/endpoint/endpoint_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Endpoint Remote Datasource.
/// Uses Public API Gateway.
abstract class EndpointRemoteDatasource {
  Future<List<EndpointDto>?> fetchEndpointFromNetwork();
}

/// Represent the Endpoint Remote Datasource Implementation
class EndpointRemoteDatasourceImpl implements EndpointRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  EndpointRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<EndpointDto>?> fetchEndpointFromNetwork() async {
    final response = await dio.get('/endpoints');

    if (response.statusCode == 304) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => EndpointDto.fromJson(json)).toList();
  }
}
