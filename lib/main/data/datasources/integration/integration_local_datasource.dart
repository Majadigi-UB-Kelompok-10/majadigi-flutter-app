import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/integration/integration_registry.dart';

/// Represent the Contract for Integration Local Datasource.
/// Uses Isar Database.
abstract class IntegrationLocalDatasource {
  Stream<List<IsarIntegrationRegistry>> watchCachedIntegration();
  Stream<List<IsarIntegrationRegistry>> watchCachedIntegrationForService(
    String serviceId,
  );
  Future<List<IsarIntegrationRegistry>> getCachedIntegration();
  Future<List<IsarIntegrationRegistry>> getCachedIntegrationForService(
    String serviceId,
  );
  Future<void> cacheIntegration(List<IsarIntegrationRegistry> integration);
}

/// Represent the Integration Local Datasource Implementation
class IntegrationLocalDatasourceImpl implements IntegrationLocalDatasource {
  final Isar _isar;
  IntegrationLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheIntegration(
    List<IsarIntegrationRegistry> integration,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.isarIntegrationRegistrys.putAll(integration);
    });
  }

  @override
  Stream<List<IsarIntegrationRegistry>> watchCachedIntegration() {
    return _isar.isarIntegrationRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<List<IsarIntegrationRegistry>> getCachedIntegration() {
    return _isar.isarIntegrationRegistrys.where().findAll();
  }

  @override
  Future<List<IsarIntegrationRegistry>> getCachedIntegrationForService(
    String serviceId,
  ) {
    return _isar.isarIntegrationRegistrys
        .filter()
        .fkServiceListIdEqualTo(serviceId)
        .findAll();
  }

  @override
  Stream<List<IsarIntegrationRegistry>> watchCachedIntegrationForService(
    String serviceId,
  ) {
    return _isar.isarIntegrationRegistrys
        .filter()
        .fkServiceListIdEqualTo(serviceId)
        .watch(fireImmediately: true);
  }
}
