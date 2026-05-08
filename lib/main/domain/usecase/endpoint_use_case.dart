import 'package:majadigi_mobile_rebuild/main/domain/entities/endpoint/endpoint_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/endpoint_repository.dart';

/// Get endpoints based on integrationId
/// @return EndpointEntity
class GetEndpointForIntegrationUseCase {
  final EndpointRepository repository;
  GetEndpointForIntegrationUseCase(this.repository);

  Future<EndpointEntity> execute(String integrationId) async {
    return await repository.getEndpointForIntegration(integrationId);
  }
}

/// Watch endpoints based on IntegrationId
/// @return Stream<EndpointEntity>
class WatchEndpointForIntegrationUseCase {
  final EndpointRepository repository;
  WatchEndpointForIntegrationUseCase(this.repository);

  Stream<EndpointEntity> execute(String integrationId) {
    return repository.watchEndpointForIntegration(integrationId);
  }
}

/// Sync endpoints from remote datasource
/// @return void
class SyncEndpointsUseCase {
  final EndpointRepository repository;
  SyncEndpointsUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncEndpoints();
  }
}