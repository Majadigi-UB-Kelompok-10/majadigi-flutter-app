import 'package:majadigi_mobile_rebuild/domain/entities/service/service_entity.dart';

/// Represent Contracts for Services
abstract class ServiceRepository {
  // SWR Specific Implementation
  Stream<List<ServiceEntity>> watchAllServices();
  Future<void> syncServices();

  // General Use Cases
  Future<List<ServiceEntity>> getAllServicesInCategory(String categoryId);
}