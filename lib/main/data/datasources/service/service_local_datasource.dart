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
  Future<({List<IsarServiceRegistry> services, DateTime lastUpdated})?> getFavoriteServices();
  Future<void> addFavoriteService(String serviceId);
  Future<void> removeFavoriteService(String serviceId);
  Future<void> processAndCacheFavorites(List<String> serviceIds, {DateTime? syncDate});
  Future<void> removeAllFavorites();
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
    if (payload.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.isarServiceRegistrys.clear();
      });
    }

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
        print("service added");
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
  Future<({List<IsarServiceRegistry> services, DateTime lastUpdated})?> getFavoriteServices() async {
    final favorites = await _isar.isarFavoriteRegistrys.where().findFirst();

    if (favorites == null) return null;

    await favorites.fkServiceId.load();

    // Using Dart 3 Records for a clean, type-safe return
    return (
    services: favorites.fkServiceId.toList(),
    lastUpdated: favorites.lastUpdated.toUtc()
    );
  }

  @override
  Stream<List<IsarServiceRegistry>> watchCachedFavoriteServices() {
    return _isar.isarFavoriteRegistrys
        .where()
        .filter()
        .idEqualTo("favorites")
        .watch(fireImmediately: true)
        .asyncMap((favoritesList) async {
      if (favoritesList.isEmpty) return [];

      final favorites = favoritesList.first;

      await favorites.fkServiceId.load();

      return favorites.fkServiceId.toList();
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
        favoriteRegistry = IsarFavoriteRegistry();
        await _isar.isarFavoriteRegistrys.put(favoriteRegistry);
      }

      favoriteRegistry.fkServiceId.add(serviceModel);

      favoriteRegistry.lastUpdated = DateTime.now().toUtc();

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

        favoriteRegistry.lastUpdated = DateTime.now().toUtc();

        await favoriteRegistry.fkServiceId.save();
      } catch (e) { /* None */ }
    });
  }

  @override
  Future<void> removeAllFavorites() async {
    await _isar.writeTxn(() async {
      await _isar.isarFavoriteRegistrys.where().deleteAll();
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

  @override
  Future<void> processAndCacheFavorites(List<String> serviceIds, {DateTime? syncDate}) async {
    await _isar.writeTxn(() async {
      // 1. Fetch or create the registry
      var favoriteRegistry = await _isar.isarFavoriteRegistrys.where().findFirst() ?? IsarFavoriteRegistry();
      await _isar.isarFavoriteRegistrys.put(favoriteRegistry);

      // 2. Load current links so we can compare them
      await favoriteRegistry.fkServiceId.load();

      // Convert to Sets for easy mathematical difference calculations
      final currentLinkedIds = favoriteRegistry.fkServiceId.map((s) => s.id).toSet();
      final incomingIds = serviceIds.toSet();

      // 3. REMOVE outdated links (Items deleted on the remote server)
      final idsToRemove = currentLinkedIds.difference(incomingIds);
      if (idsToRemove.isNotEmpty) {
        final itemsToRemove = favoriteRegistry.fkServiceId.where((s) => idsToRemove.contains(s.id)).toList();
        for (final item in itemsToRemove) {
          favoriteRegistry.fkServiceId.remove(item);
        }
      }

      // 4. ADD new links (Items added on the remote server)
      final idsToAdd = incomingIds.difference(currentLinkedIds);
      for (final id in idsToAdd) {
        final serviceModel = await _isar.isarServiceRegistrys.where().idEqualTo(id).findFirst();
        if (serviceModel != null) {
          // Isar inherently prevents duplicates, but filtering idsToAdd saves us
          // from making unnecessary database reads for items we already have.
          favoriteRegistry.fkServiceId.add(serviceModel);
        }
      }

      // 5. Save everything
      favoriteRegistry.lastUpdated = syncDate?.toUtc() ?? DateTime.now().toUtc();
      await _isar.isarFavoriteRegistrys.put(favoriteRegistry);
      await favoriteRegistry.fkServiceId.save();
    });
  }
}
