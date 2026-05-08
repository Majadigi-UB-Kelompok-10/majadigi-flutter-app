import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/endpoint/endpoint_registry.dart';

/// Represent the Contract for Endpoint Local Datasource.
/// Uses Isar Database.
abstract class EndpointLocalDatasource {
  Stream<List<IsarEndpointRegistry>> watchCachedEndpoint();
  Stream<List<IsarEndpointRegistry>> watchCachedEndpointForIntegration(
    String fkEndpointId,
  );
  Future<List<IsarEndpointRegistry>> getCachedEndpoint();
  Future<List<IsarEndpointRegistry>> getCachedEndpointForIntegration(
    String fkEndpointId,
  );
  Future<void> cacheEndpoint(List<IsarEndpointRegistry> endpoint);
}

/// Represent the Endpoint Local Datasource Implementation
class EndpointLocalDatasourceImpl implements EndpointLocalDatasource {
  final Isar _isar;
  EndpointLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheEndpoint(List<IsarEndpointRegistry> endpoint) async {
    await _isar.writeTxn(() async {
      await _isar.isarEndpointRegistrys.putAll(endpoint);
    });
  }

  @override
  Stream<List<IsarEndpointRegistry>> watchCachedEndpoint() {
    return _isar.isarEndpointRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<IsarEndpointRegistry>> watchCachedEndpointForIntegration(
    String fkEndpointId,
  ) {
    return _isar.isarEndpointRegistrys
        .filter()
        .idEqualTo(fkEndpointId)
        .watch(fireImmediately: true);
  }

  @override
  Future<List<IsarEndpointRegistry>> getCachedEndpoint() {
    return _isar.isarEndpointRegistrys.where().findAll();
  }

  @override
  Future<List<IsarEndpointRegistry>> getCachedEndpointForIntegration(
    String fkEndpointId,
  ) async {
    final endpoint = await _isar.isarEndpointRegistrys
        .filter()
        .idEqualTo(fkEndpointId)
        .findFirst();

    if (endpoint == null) {
      return [];
    }

    return [endpoint];
  }
}
