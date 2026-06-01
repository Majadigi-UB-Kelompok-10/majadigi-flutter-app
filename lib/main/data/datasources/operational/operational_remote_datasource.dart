import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/operational/operational_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Operational Remote Datasource.
/// Uses Public API Gateway.
abstract class OperationalRemoteDatasource {
  Future<List<OperationalDto>?> fetchOperationalFromNetwork();
}

/// Represent the Operational Remote Datasource Implementation
class OperationalRemoteDatasourceImpl implements OperationalRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  OperationalRemoteDatasourceImpl({required this.dio, this.zstandard});

  @override
  Future<List<OperationalDto>?> fetchOperationalFromNetwork() async {
    final response = await dio.get('/operational');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);
    return (data["data"] as List).map((json) => OperationalDto.fromJson(json)).toList();
  }
}
