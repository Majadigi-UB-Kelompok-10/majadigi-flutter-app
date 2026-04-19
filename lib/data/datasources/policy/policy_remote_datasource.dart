import 'package:majadigi_mobile_rebuild/data/models/dto/policy/policy_dto.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:dio/dio.dart';

/// Represent the Contract for Policy Remote Datasource.
/// Uses Public API Gateway
abstract class PolicyRemoteDatasource {
  Future<List<PolicyDto>> fetchPoliciesFromNetwork();
}

/// Represent the Policy Remote Datasource Implementation
class PolicyRemoteDatasourceImpl implements PolicyRemoteDatasource {
  final Dio _dio;
  PolicyRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<PolicyDto>> fetchPoliciesFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/policies');
    final data = response.data as List;
    return data.map((json) => PolicyDto.fromJson(json)).toList();
  }
}