import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDatasource localDatasource;
  final ServiceRemoteDatasource remoteDatasource;

  ServiceRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  // SWR Implementation from Stream
  @override
  Stream<List<ServiceEntity>> watchAllServices() {
    return localDatasource.watchCachedServices().map((services) {
      return services.map((service) => service.toEntity()).toList();
    });
  }

  // Sync database with remote datasource
  @override
  Future<void> syncServices() async {
    try {
      final normalizedPayload = await remoteDatasource.fetchNormalizedServicesFromNetwork();

      if (normalizedPayload == null) return;

      await localDatasource.processAndCacheServices(normalizedPayload);
    } catch (e) { /* None */ }
  }

  @override
  Future<List<ServiceEntity>> getAllServicesInCategory(String categoryId) async {
    return await localDatasource.getCachedServicesInCategory(categoryId).then((services) {
      return services.map((service) => service.toEntity()).toList();
    });
  }

  @override
  Future<void> addFavoriteService(String serviceId) async {
    // Is semi-offline by sync
    await localDatasource.addFavoriteService(serviceId);

    await syncFavorites();
  }

  @override
  Stream<List<ServiceEntity>> watchFavoritedServices() {
    return localDatasource.watchCachedFavoriteServices().map((services) {
      return services.map((service) => service.toEntity()).toList();
    });
  }

  @override
  Future<void> removeFavoriteService(String serviceId) async {
    // Is semi-offline by sync
    await localDatasource.removeFavoriteService(serviceId);

    await syncFavorites();
  }

  @override
  Future<List<ServiceEntity>> searchServicesByQuery(String query) async {
    final services = await localDatasource.searchCachedServiceByQuery(query);

    return services.map((service) => service.toEntity()).toList();
  }

  @override
  Future<void> syncFavorites() async {
    try {
      final remotePayload = await remoteDatasource.fetchRemoteFavorite();
      final localData = await localDatasource.getFavoriteServices();

      // Both are empty, nothing to do
      if (remotePayload == null && localData == null) return;

      // Use Epoch 0 as a fallback for null dates to make comparisons easy
      final remoteDate = remotePayload?.updatedAt?.toUtc() ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final localDate = localData?.lastUpdated.toUtc() ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      // SCENARIO 1: Remote is newer OR Local has never been created
      if (remoteDate.isAfter(localDate) || localData == null) {
        final remoteServiceIds = remotePayload?.serviceIds ?? [];

        // Overwrite local with remote data, and FORCE the local timestamp
        // to match the remote timestamp so they are perfectly aligned.
        await localDatasource.processAndCacheFavorites(
          remoteServiceIds,
          syncDate: remoteDate,
        );
        return;
      }

      // SCENARIO 2: Local is newer OR Remote is empty
      if (localDate.isAfter(remoteDate) || remotePayload == null) {
        final localServiceIds = localData.services.map((s) => s.id).toList();
        final remoteServiceIds = remotePayload?.serviceIds ?? [];

        // Calculate Deltas
        final itemsToAdd = localServiceIds.where((id) => !remoteServiceIds.contains(id)).toList();
        final itemsToRemove = remoteServiceIds.where((id) => !localServiceIds.contains(id)).toList();

        // If there's only one item
        if (itemsToAdd.isNotEmpty && itemsToAdd.length == 1) {
          await remoteDatasource.addRemoteFavorite(itemsToAdd.first);
        } else if (itemsToAdd.isNotEmpty) {
          await remoteDatasource.addBatchRemoteFavorite(itemsToAdd);
        }

        if (itemsToRemove.isNotEmpty && itemsToRemove.length == 1) {
          await remoteDatasource.removeRemoteFavorite(itemsToRemove.first);
        } else if (itemsToRemove.isNotEmpty) {
          await remoteDatasource.removeBatchRemoteFavorite(itemsToRemove);
        }

        // After modifying the remote, fetch the remote again just to grab
        // the server's newly generated timestamp, then update your local DB
        // with that exact timestamp so they don't fall out of sync.
        final updatedRemote = await remoteDatasource.fetchRemoteFavorite();
        if (updatedRemote != null) {
          await localDatasource.processAndCacheFavorites(
            updatedRemote.serviceIds ?? [],
            syncDate: updatedRemote.updatedAt,
          );
        }
      }

      // SCENARIO 3: Timestamps are equal
      // No action needed as both sides are synchronized.
    } catch (e) { /* None */ }
  }

  /// Only meant to be used during offline skip
  @override
  Future<void> clearFavorites() async {
    await localDatasource.removeAllFavorites();
  }
}