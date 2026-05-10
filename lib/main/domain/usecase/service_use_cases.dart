import 'package:majadigi_mobile_rebuild/main/domain/repositories/service_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

/// Get all available services in a specific category as a List<ServiceEntity>
/// @return List<ServiceEntity>
class GetAllServicesInCategoryUseCase {
  final ServiceRepository repository;

  GetAllServicesInCategoryUseCase(this.repository);

  Future<List<ServiceEntity>> execute(String categoryId) async {
    return await repository.getAllServicesInCategory(categoryId);
  }
}

/// Watch services from Isar Database
/// @return Stream<List<ServiceEntity>>
class WatchAllServicesUseCase {
  final ServiceRepository repository;

  WatchAllServicesUseCase(this.repository);

  Stream<List<ServiceEntity>> execute() {
    return repository.watchAllServices();
  }
}

/// Sync services from Remote Data Sources
/// @return void
class SyncServicesUseCase {
  final ServiceRepository repository;

  SyncServicesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncServices();
  }
}

/// Watch All Favorites
class WatchAllFavoriteUseCase {
  final ServiceRepository repository;

  WatchAllFavoriteUseCase(this.repository);

  Stream<List<ServiceEntity>> execute() {
    return repository.watchFavoritedServices();
  }
}

/// Add Favorites
class AddFavoriteUseCase {
  final ServiceRepository repository;
  
  AddFavoriteUseCase(this.repository);
  
  Future<void> execute(String serviceId) async {
    return await repository.addFavoriteService(serviceId);
  }
}

/// Remove Favories
class RemoveFavoriteUseCase {
  final ServiceRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> execute(String serviceId) async {
    return await repository.removeFavoriteService(serviceId);
  }
}
