import 'package:majadigi_mobile_rebuild/domain/entities/integration/integration_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/integration_repository.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/integration/integration_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/integration/integration_remote_datasource.dart';

class IntegrationRepositoryImpl implements IntegrationRepository {
  final IntegrationLocalDatasource localDatasource;
  final IntegrationRemoteDatasource remoteDatasource;

  IntegrationRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<List<IntegrationEntity>> getAllIntegrationForService(String serviceId) {
    return localDatasource.getCachedIntegrationForService(serviceId).then((integration) {
      return integration.map((integration) => integration.toEntity()).toList();
    });
  }

  @override
  Future<void> syncIntegrations() async {
    try {
      final integration = await remoteDatasource.fetchIntegrationFromNetwork();

      if (integration == null) return;

      final integrationIsar = integration.map((integration) => integration.toIsar()).toList();

      localDatasource.cacheIntegration(integrationIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<List<IntegrationEntity>> watchAllIntegrationForService(String serviceId) {
    return localDatasource.watchCachedIntegrationForService(serviceId).map((integration) {
      return integration.map((integration) => integration.toEntity()).toList();
    });
  }
}