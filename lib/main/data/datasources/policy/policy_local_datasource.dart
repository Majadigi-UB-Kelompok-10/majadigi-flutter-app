import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/policy/policy_registry.dart';

/// Represent the Contract for Policy Local Datasource.
/// Uses Isar Database.
abstract class PolicyLocalDatasource {
  Stream<List<IsarPolicyRegistry>> watchCachedPolicies();
  Stream<List<IsarPolicyRegistry>> watchCachedPoliciesForService(String serviceId);
  Future<List<IsarPolicyRegistry>> getCachedPolicies();
  Future<List<IsarPolicyRegistry>> getCachedPoliciesForService(String serviceId);
  Future<void> cachePolicies(List<IsarPolicyRegistry> policies);
}

/// Represent the Policy Local Datasource Implementation
class PolicyLocalDatasourceImpl implements PolicyLocalDatasource {
  final Isar _isar;
  PolicyLocalDatasourceImpl(this._isar);

  @override
  Stream<List<IsarPolicyRegistry>> watchCachedPolicies() {
    return _isar.isarPolicyRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<void> cachePolicies(List<IsarPolicyRegistry> policies) async {
    await _isar.writeTxn(() async {
      await _isar.isarPolicyRegistrys.putAllById(policies);
    });
  }

  @override
  Future<List<IsarPolicyRegistry>> getCachedPolicies() {
    return _isar.isarPolicyRegistrys.where().findAll();
  }

  @override
  Future<List<IsarPolicyRegistry>> getCachedPoliciesForService(String serviceId) {
    return _isar.isarPolicyRegistrys.filter().fkServiceListIdEqualTo(serviceId).findAll();
  }

  @override
  Stream<List<IsarPolicyRegistry>> watchCachedPoliciesForService(String serviceId) {
    return _isar.isarPolicyRegistrys.filter().fkServiceListIdEqualTo(serviceId).watch(fireImmediately: true);
  }
}