import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

/// Represent Contracts for Services
abstract class ServiceRepository {
  // SWR Specific Implementation
  Stream<List<ServiceEntity>> watchAllServices();
  Future<void> syncServices();

  // General Use Cases
  Future<List<ServiceEntity>> getAllServicesInCategory(String categoryId);

  // Favorite Use Case
  Stream<List<ServiceEntity>> watchFavoritedServices();
  Future<void> addFavoriteService(String serviceId);
  Future<void> removeFavoriteService(String serviceId);

  // Search by String Use Case
  Future<List<ServiceEntity>> searchServicesByQuery(String query);
}