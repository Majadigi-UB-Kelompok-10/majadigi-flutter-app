import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/operational/operational_registry.dart';

/// Represent the Contract for Operational Local Datasource.
/// Uses Isar Database.
abstract class OperationalLocalDatasource {
  Stream<List<IsarOperationalRegistry>> watchCachedOperational();
  Future<List<IsarOperationalRegistry>> getCachedOperational();
  Future<void> cacheOperational(List<IsarOperationalRegistry> operational);
}

/// Represent the Operational Local Datasource Implementation
class OperationalLocalDatasourceImpl implements OperationalLocalDatasource {
  final Isar _isar;
  OperationalLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheOperational(List<IsarOperationalRegistry> operational) async {
    await _isar.writeTxn(() async {
      await _isar.isarOperationalRegistrys.putAll(operational);
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
}