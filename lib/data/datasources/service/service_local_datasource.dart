import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/dto/normalized_service_category/normalized_service_category_dto.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/fast_hash.dart';

/// Represent the Contract for Service Local Datasource.
/// Uses Isar Database.
abstract class ServiceLocalDatasource {
  Stream<List<IsarServiceRegistry>> watchCachedServices();
  Future<List<IsarServiceRegistry>> getCachedServices();
  Future<List<IsarServiceRegistry>> getCachedServicesInCategory(String categoryId);
  Future<void> processAndCacheServices(List<NormalizedServiceCategoryDto> payload);
}

/// Represent the Service Local Datasource Implementation
class ServiceLocalDatasourceImpl implements ServiceLocalDatasource {
  final Isar _isar;
  ServiceLocalDatasourceImpl(this._isar);

  @override
  Stream<List<IsarServiceRegistry>> watchCachedServices() {
    return _isar.isarServiceRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<List<IsarServiceRegistry>> getCachedServices() async {
    return await _isar.isarServiceRegistrys.where().findAll();
  }

  @override
  Future<void> processAndCacheServices(List<NormalizedServiceCategoryDto> payload) async {
    await _isar.writeTxn(() async {
      for (NormalizedServiceCategoryDto normalizedService in payload) {
        final linkedCategories = await _isar.isarCategoryRegistrys.getAll(
          normalizedService.categoryIds!.map((id) => fastHash(id)).toList()
        );

        final serviceIsar = normalizedService.toIsar()..categories.addAll(linkedCategories.whereType<IsarCategoryRegistry>());
        await serviceIsar.categories.save();
      }
    });
  }

  @override
  Future<List<IsarServiceRegistry>> getCachedServicesInCategory(String categoryId) async {
    final category = await _isar.isarCategoryRegistrys.where().filter().idEqualTo(categoryId).findFirst();

    if (category == null) {
      return [];
    }

    await category.services.load();

    return category.services.toList();
  }
}