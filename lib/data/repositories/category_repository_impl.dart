import 'package:majadigi_mobile_rebuild/domain/entities/category/category_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/category_repository.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/category/category_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/category/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource localDatasource;
  final CategoryRemoteDatasource remoteDatasource;

  CategoryRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<List<CategoryEntity>> getAllCategoryForService(String serviceId) {
    return localDatasource.getCachedCategoryByService(serviceId).then((category) {
      return category.map((category) => category.toEntity()).toList();
    });
  }

  @override
  Future<void> syncCategory() async {
    try {
      final categories = await remoteDatasource.fetchCategoryFromNetwork();

      final categoryIsar = categories.map((category) => category.toIsar()).toList();

      localDatasource.cacheCategory(categoryIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<List<CategoryEntity>> watchAllCategory() {
    return localDatasource.watchCachedCategory().map((category) {
      return category.map((category) => category.toEntity()).toList();
    });
  }
}