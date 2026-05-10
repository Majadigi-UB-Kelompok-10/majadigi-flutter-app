import 'package:majadigi_mobile_rebuild/main/domain/repositories/integration_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';

/// Watch Integrations based on ServiceId
/// @return Stream<List<IntegrationEntity>>
class WatchIntegrationsForServiceUseCase {
  final IntegrationRepository repository;

  WatchIntegrationsForServiceUseCase(this.repository);

  Stream<List<IntegrationEntity>> execute(String serviceId) {
    return repository.watchAllIntegrationForService(serviceId);
  }
}

/// Sync Integrations from Remote Datasource
/// @return void
class SyncIntegrationsUseCase {
  final IntegrationRepository repository;

  SyncIntegrationsUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncIntegrations();
  }
}

/// Get All integrations based on ServiceId
/// @return List<IntegrationEntity>
class GetAllIntegrationsForServiceUseCase {
  final IntegrationRepository repository;

  GetAllIntegrationsForServiceUseCase(this.repository);

  Future<List<IntegrationEntity>?> execute(String serviceId) async {
    return await repository.getAllIntegrationForService(serviceId);
  }
}