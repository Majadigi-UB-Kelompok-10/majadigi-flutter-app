import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/operational/operational_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Operational Remote Datasource.
/// Uses Public API Gateway.
abstract class OperationalRemoteDatasource {
  Future<List<OperationalDto>> fetchOperationalFromNetwork();
}

/// Represent the Operational Remote Datasource Implementation
class OperationalRemoteDatasourceImpl implements OperationalRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  OperationalRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<OperationalDto>> fetchOperationalFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await dio.get('/operational');
    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => OperationalDto.fromJson(json)).toList();
  }
}
