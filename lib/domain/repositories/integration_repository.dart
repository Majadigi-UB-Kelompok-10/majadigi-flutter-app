import 'package:majadigi_mobile_rebuild/domain/entities/integration/integration_entity.dart';

/// Represent Contract for Integrations
abstract class IntegrationRepository {
  Future<List<IntegrationEntity>> getAllIntegrationForService(String serviceId);
}