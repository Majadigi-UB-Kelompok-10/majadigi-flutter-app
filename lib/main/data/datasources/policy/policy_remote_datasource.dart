import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/policy/policy_dto.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/remote_config.dart';
import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Policy Remote Datasource.
/// Uses Public API Gateway
abstract class PolicyRemoteDatasource {
  Future<List<PolicyDto>?> fetchPoliciesFromNetwork();
}

/// Represent the Policy Remote Datasource Implementation
class PolicyRemoteDatasourceImpl implements PolicyRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  PolicyRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<PolicyDto>?> fetchPoliciesFromNetwork() async {
    final response = await dio.get('/policies');
    if (response.statusCode == 304) return null;
    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => PolicyDto.fromJson(json)).toList();
  }
}
