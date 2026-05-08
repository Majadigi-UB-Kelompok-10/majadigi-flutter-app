import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/integration/integration_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Integration Remote Datasource.
/// Uses Public API Gateway
abstract class IntegrationRemoteDatasource {
  Future<List<IntegrationDto>?> fetchIntegrationFromNetwork();
}

/// Represent the Integration Remote Datasource Implementation
class IntegrationRemoteDatasourceImpl implements IntegrationRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  IntegrationRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<IntegrationDto>?> fetchIntegrationFromNetwork() async {
    final response = await dio.get('/integrations');

    if (response.statusCode == 304) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => IntegrationDto.fromJson(json)).toList();
  }
}
