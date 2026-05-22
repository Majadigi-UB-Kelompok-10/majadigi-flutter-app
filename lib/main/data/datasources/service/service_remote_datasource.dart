import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/favorites/favorite_dto.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/normalized_service_category/normalized_service_category_dto.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Service Remote Datasource
/// uses Public API Gateway
abstract class ServiceRemoteDatasource {
  Future<List<NormalizedServiceCategoryDto>?> fetchNormalizedServicesFromNetwork();
  Future<FavoriteDto?> fetchRemoteFavorite();
  Future<bool> addRemoteFavorite(String id);
  Future<bool> addBatchRemoteFavorite(List<String> ids);
  Future<bool> removeRemoteFavorite(String id);
  Future<bool> removeBatchRemoteFavorite(List<String> ids);
}

/// Represent the Service Remote Datasource Implementation
class ServiceRemoteDatasourceImpl implements ServiceRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  ServiceRemoteDatasourceImpl({required this.dio, this.zstandard});

  @override
  Future<List<NormalizedServiceCategoryDto>?>
  fetchNormalizedServicesFromNetwork() async {
    final response = await dio.get('/services-has-categories/normalized');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    return (data["data"] as List)
        .map((json) => NormalizedServiceCategoryDto.fromJson(json))
        .toList();
  }

  @override
  Future<bool> addRemoteFavorite(String id) async {
    final response = await dio.post('/user/auth/favorites', data: {
      "service_ids": [id]
    });

    // Failed
    if (response.statusCode != 201) return false;

    return true;
  }

  @override
  Future<bool> addBatchRemoteFavorite(List<String> ids) async {
    final response = await dio.post('/user/auth/favorites', data: {
      "service_ids": ids
    });

    // Failed
    if (response.statusCode != 201) return false;

    return true;
  }

  @override
  Future<bool> removeRemoteFavorite(String id) async {
    final response = await dio.delete('/user/auth/favorites', data: {
      "service_ids": [id]
    });

    // Failed
    if (response.statusCode != 200) return false;

    return true;
  }

  @override
  Future<bool> removeBatchRemoteFavorite(List<String> ids) async {
    final response = await dio.delete('/user/auth/favorites', data: {
      "service_ids": ids
    });

    // Failed
    if (response.statusCode != 200) return false;

    return true;
  }

  @override
  Future<FavoriteDto?> fetchRemoteFavorite() async {
    final response = await dio.get('/user/auth/favorites');

    if (response.statusCode != 200) return null;

    final data = await cleanupData(zstandard: zstandard, response: response);

    final favoriteDto = FavoriteDto.fromJson(data["data"] as Map<String, dynamic>);

    return favoriteDto;
  }
}
