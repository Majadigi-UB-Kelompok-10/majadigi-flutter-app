import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/normalized_service_category/normalized_service_category_dto.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Service Remote Datasource
/// uses Public API Gateway
abstract class ServiceRemoteDatasource {
  Future<List<NormalizedServiceCategoryDto>?>
  fetchNormalizedServicesFromNetwork();
}

/// Represent the Service Remote Datasource Implementation
class ServiceRemoteDatasourceImpl implements ServiceRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  ServiceRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<NormalizedServiceCategoryDto>?>
  fetchNormalizedServicesFromNetwork() async {
    final response = await dio.get('/services/normalized');

    if (response.statusCode == 304) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return data
        .map((json) => NormalizedServiceCategoryDto.fromJson(json))
        .toList();
  }
}
