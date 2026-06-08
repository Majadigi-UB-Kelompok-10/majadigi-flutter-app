import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/category_repository.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/category/category_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/category/category_remote_datasource.dart';

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

      if (categories == null) return;

      final categoryIsar = categories.map((category) => category.toIsar()).toList();

      await localDatasource.cacheCategory(categoryIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<List<CategoryEntity>> watchAllCategory() {
    return localDatasource.watchCachedCategory().map((category) {
      return category.map((category) => category.toEntity()).toList();
    });
  }

  @override
  Future<List<CategoryEntity>> getUserCategoryPreference() async {
    // 1. Always try local first (SWR — local is source of truth)
    final localIds = await localDatasource.getUserCategoryPreference();

    if (localIds.isNotEmpty) {
      final categories = await localDatasource.getCachedCategoryByCategoryIds(localIds);
      return categories.map((c) => c.toEntity()).toList();
    }

    // 2. If local is empty, try remote (initial login / fresh install)
    try {
      final remoteIds = await remoteDatasource.getUserCategoryPreference();

      if (remoteIds != null && remoteIds.isNotEmpty) {
        // Persist to local for future reads
        await localDatasource.saveUserCategoryPreference(remoteIds);
        final categories = await localDatasource.getCachedCategoryByCategoryIds(remoteIds);
        return categories.map((c) => c.toEntity()).toList();
      }
    } catch (_) { /* Offline — just return empty */ }

    return [];
  }

  @override
  Future<bool> saveUserCategoryPreference(List<String> categoryIds) async {
    // 1. Always save locally first (SWR — local is source of truth)
    await localDatasource.saveUserCategoryPreference(categoryIds);

    // 2. Fire-and-forget sync to remote
    try {
      await remoteDatasource.saveUserCategoryPreference(categoryIds);
    } catch (_) { /* Will sync on next startup */ }

    return true;
  }

  @override
  Future<void> clearUserCategoryPreference() async {
    await localDatasource.clearUserCategoryPreference();
  }
}