import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/operational/operational_dto.dart';

/// Represent the Contract for Operational Remote Datasource.
/// Uses Public API Gateway.
abstract class OperationalRemoteDatasource {
  Future<List<OperationalDto>> fetchOperationalFromNetwork();
}

/// Represent the Operational Remote Datasource Implementation
class OperationalRemoteDatasourceImpl implements OperationalRemoteDatasource {
  final Dio _dio;
  OperationalRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<OperationalDto>> fetchOperationalFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/operational');
    final data = response.data as List;
    return data.map((json) => OperationalDto.fromJson(json)).toList();
  }
}