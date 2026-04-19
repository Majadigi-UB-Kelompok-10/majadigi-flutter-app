import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/remote_config.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/category/category_dto.dart';

/// Represent the Contract for Category Remote Datasource.
/// Uses Public API Gateway.
abstract class CategoryRemoteDatasource {
  Future<List<CategoryDto>> fetchCategoryFromNetwork();
}

/// Represent the Category Remote Datasource Implementation
class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final Dio _dio;
  CategoryRemoteDatasourceImpl(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  Future<List<CategoryDto>> fetchCategoryFromNetwork() async {
    // TODO: CHANGE THIS TO REAL API GATEWAY
    final response = await _dio.get('/category');
    final data = response.data as List;
    return data.map((json) => CategoryDto.fromJson(json)).toList();
  }
}