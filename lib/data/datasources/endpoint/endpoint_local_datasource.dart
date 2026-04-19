import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/endpoint/endpoint_registry.dart';

/// Represent the Contract for Endpoint Local Datasource.
/// Uses Isar Database.
abstract class EndpointLocalDatasource {
  Stream<List<IsarEndpointRegistry>> watchCachedEndpoint();
  Future<List<IsarEndpointRegistry>> getCachedEndpoint();
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
  Future<List<IsarEndpointRegistry>> getCachedEndpoint() {
    return _isar.isarEndpointRegistrys.where().findAll();
  }
}