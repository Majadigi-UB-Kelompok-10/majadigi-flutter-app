import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/operational/operational_registry.dart';

/// Represent the Contract for Operational Local Datasource.
/// Uses Isar Database.
abstract class OperationalLocalDatasource {
  Stream<List<IsarOperationalRegistry>> watchCachedOperational();
  Stream<List<IsarOperationalRegistry>> watchCachedOperationalForService(String serviceId);
  Future<List<IsarOperationalRegistry>> getCachedOperational();
  Future<List<IsarOperationalRegistry>> getCachedOperationalForService(String serviceId);
  Future<void> cacheOperational(List<IsarOperationalRegistry> operational);
}

/// Represent the Operational Local Datasource Implementation
class OperationalLocalDatasourceImpl implements OperationalLocalDatasource {
  final Isar _isar;
  OperationalLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheOperational(List<IsarOperationalRegistry> operational) async {
    await _isar.writeTxn(() async {
      await _isar.isarOperationalRegistrys.putAllById(operational);
    });
  }

  @override
  Stream<List<IsarOperationalRegistry>> watchCachedOperational() {
    return _isar.isarOperationalRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<List<IsarOperationalRegistry>> getCachedOperational() {
    return _isar.isarOperationalRegistrys.where().findAll();
  }

  @override
  Future<List<IsarOperationalRegistry>> getCachedOperationalForService(String serviceId) {
    return _isar.isarOperationalRegistrys.filter().fkServiceListIdEqualTo(serviceId).findAll();
  }

  @override
  Stream<List<IsarOperationalRegistry>> watchCachedOperationalForService(String serviceId) {
    return _isar.isarOperationalRegistrys.filter().fkServiceListIdEqualTo(serviceId).watch(fireImmediately: true);
  }
}