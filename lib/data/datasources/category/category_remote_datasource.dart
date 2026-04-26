import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/category/category_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Category Remote Datasource.
/// Uses Public API Gateway.
abstract class CategoryRemoteDatasource {
  Future<List<CategoryDto>> fetchCategoryFromNetwork();
}

/// Represent the Category Remote Datasource Implementation
class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  CategoryRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<CategoryDto>> fetchCategoryFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await dio.get('/category');
    final data = await cleanupData(zstandard: zstandard, response: response);
    return data.map((json) => CategoryDto.fromJson(json)).toList();
  }
}
