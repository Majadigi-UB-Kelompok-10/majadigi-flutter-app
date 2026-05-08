import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';

/// Represent Contract for Integrations
abstract class IntegrationRepository {
  // SWR Specific Implementation
  Stream<List<IntegrationEntity>> watchAllIntegrationForService(String serviceId);
  Future<void> syncIntegrations();

  // General Use Case
  Future<List<IntegrationEntity>> getAllIntegrationForService(String serviceId);
}