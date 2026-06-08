import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/prefer_category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';

/// Represent the Contract for Category Local Datasource.
/// Uses Isar Database.
abstract class CategoryLocalDatasource {
  Stream<List<IsarCategoryRegistry>> watchCachedCategory();
  Future<List<IsarCategoryRegistry>> getCachedCategory();
  Future<List<IsarCategoryRegistry>> getCachedCategoryByCategoryIds(List<String> categoryIds);
  Future<List<IsarCategoryRegistry>> getCachedCategoryByService(
    String serviceId,
  );
  Future<void> cacheCategory(List<IsarCategoryRegistry> category);
  Future<bool> saveUserCategoryPreference(List<String> categoryIds);
  Future<List<String>> getUserCategoryPreference();
  Future<void> clearUserCategoryPreference();
}

/// Represent the Category Local Datasource Implementation
class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final Isar _isar;
  CategoryLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheCategory(List<IsarCategoryRegistry> category) async {
    await _isar.writeTxn(() async {
      await _isar.isarCategoryRegistrys.putAllById(category);
    });
  }

  @override
  Stream<List<IsarCategoryRegistry>> watchCachedCategory() {
    return _isar.isarCategoryRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<List<IsarCategoryRegistry>> getCachedCategory() {
    return _isar.isarCategoryRegistrys.where().findAll();
  }

  @override
  Future<List<IsarCategoryRegistry>> getCachedCategoryByService(
    String serviceId,
  ) async {
    final service = await _isar.isarServiceRegistrys
        .filter()
        .idEqualTo(serviceId)
        .findFirst();

    if (service == null) {
      return [];
    }

    await service.categories.load();

    return service.categories.toList();
  }

  @override
  Future<List<IsarCategoryRegistry>> getCachedCategoryByCategoryIds(List<String> categoryIds) async {
    final results = await _isar.isarCategoryRegistrys.getAllById(categoryIds);
    return results.whereType<IsarCategoryRegistry>().toList();
  }

  @override
  Future<List<String>> getUserCategoryPreference() async {
    final record = await _isar.isarPreferCategoryRegistrys
        .filter()
        .idEqualTo("preferred_categories")
        .findFirst();
    return record?.categoryIds ?? [];
  }

  @override
  Future<bool> saveUserCategoryPreference(List<String> categoryIds) async {
    await _isar.writeTxn(() async {
      final record = IsarPreferCategoryRegistry()
        ..categoryIds = categoryIds;
      await _isar.isarPreferCategoryRegistrys.putById(record);
    });
    return true;
  }

  @override
  Future<void> clearUserCategoryPreference() async {
    await _isar.writeTxn(() async {
      await _isar.isarPreferCategoryRegistrys.clear();
    });
  }
}

