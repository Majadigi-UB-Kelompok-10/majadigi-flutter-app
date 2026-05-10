import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/normalized_service_category/normalized_service_category_dto.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/favorites/favorite_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';

/// Represent the Contract for Service Local Datasource.
/// Uses Isar Database.
abstract class ServiceLocalDatasource {
  Stream<List<IsarServiceRegistry>> watchCachedServices();
  Future<List<IsarServiceRegistry>> getCachedServices();
  Future<List<IsarServiceRegistry>> getCachedServicesInCategory(
    String categoryId,
  );
  Future<void> processAndCacheServices(
    List<NormalizedServiceCategoryDto> payload,
  );
  Stream<List<IsarServiceRegistry>> watchCachedFavoriteServices();
  Future<List<IsarServiceRegistry>> getFavoriteServices();
  Future<void> addFavoriteService(String serviceId);
  Future<void> removeFavoriteService(String serviceId);
  Future<List<IsarServiceRegistry>> searchCachedServiceByQuery(String query);
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
  Future<void> processAndCacheServices(
    List<NormalizedServiceCategoryDto> payload,
  ) async {
    await _isar.writeTxn(() async {
      for (NormalizedServiceCategoryDto normalizedService in payload) {
        final linkedCategories = await _isar.isarCategoryRegistrys.getAll(
          normalizedService.categoryIds!.map((id) => fastHash(id)).toList(),
        );

        // Create the Isar object once
        final serviceIsar = normalizedService.toIsar();

        // Save Service to Isar first (makes it managed by Isar)
        await _isar.isarServiceRegistrys.put(serviceIsar);

        // Now link categories using the same managed object
        serviceIsar.categories.addAll(
          linkedCategories.whereType<IsarCategoryRegistry>(),
        );
        await serviceIsar.categories.save();
      }
    });
  }

  @override
  Future<List<IsarServiceRegistry>> getCachedServicesInCategory(
    String categoryId,
  ) async {
    final category = await _isar.isarCategoryRegistrys
        .filter()
        .idEqualTo(categoryId)
        .findFirst();

    if (category == null) {
      return [];
    }

    await category.services.load();

    return category.services.toList();
  }

  @override
  Future<List<IsarServiceRegistry>> getFavoriteServices() async {
    final favorites = await _isar.isarFavoriteRegistrys.where().findAll();

    if (favorites.isEmpty) {
      return [];
    }

    await Future.wait(favorites.map((fav) => fav.fkServiceId.load()));

    return favorites.expand((fav) => fav.fkServiceId).toSet().toList();
  }

  @override
  Stream<List<IsarServiceRegistry>> watchCachedFavoriteServices() {
    return _isar.isarFavoriteRegistrys
        .where()
        .filter()
        .idEqualTo('default_user_favorites')
        .watch(fireImmediately: true)
        .asyncMap((favorites) async {

      if (favorites.isEmpty) return [];

      await Future.wait(favorites.map((fav) => fav.fkServiceId.load()));

      final services = favorites
          .expand((fav) => fav.fkServiceId)
          .toSet()
          .toList();

      return services;
    });
  }

  @override
  Future<void> addFavoriteService(String serviceId) async {
    final serviceModel = await _isar.isarServiceRegistrys.where().idEqualTo(serviceId).findFirst();

    if (serviceModel == null) return;

    // Create a favorite registry
    await _isar.writeTxn(() async {
      var favoriteRegistry = await _isar.isarFavoriteRegistrys.where().findFirst();

      if (favoriteRegistry == null) {
        favoriteRegistry = IsarFavoriteRegistry()..id = 'default_user_favorites';
        await _isar.isarFavoriteRegistrys.put(favoriteRegistry);
      }

      favoriteRegistry.fkServiceId.add(serviceModel);

      favoriteRegistry.lastUpdated = DateTime.now();

      await favoriteRegistry.fkServiceId.save();
    });
  }

  @override
  Future<void> removeFavoriteService(String serviceId) async {
    final favoriteRegistry = await _isar.isarFavoriteRegistrys.where().findFirst();

    if (favoriteRegistry == null) return;

    await _isar.writeTxn(() async {
      await favoriteRegistry.fkServiceId.load();

      try {
        final serviceToRemove = favoriteRegistry.fkServiceId
            .firstWhere((s) => s.id == serviceId);

        favoriteRegistry.fkServiceId.remove(serviceToRemove);

        favoriteRegistry.lastUpdated = DateTime.now();

        await favoriteRegistry.fkServiceId.save();
      } catch (e) { /* None */ }
    });
  }

  @override
  Future<List<IsarServiceRegistry>> searchCachedServiceByQuery(String query) async {
    return await _isar
        .isarServiceRegistrys
        .where()
        .contentWordsElementStartsWith(query)
        .or()
        .revContentWordsElementStartsWith(query.split('').reversed.join(''))
        .findAll();
  }
}
