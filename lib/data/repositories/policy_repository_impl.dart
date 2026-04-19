import 'package:majadigi_mobile_rebuild/data/datasources/policy/policy_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/policy/policy_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/policy/policy_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/policy_repository.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyLocalDatasource localDatasource;
  final PolicyRemoteDatasource remoteDatasource;

  PolicyRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<PolicyEntity> getPolicyForService(String serviceId) {
    return localDatasource.getCachedPoliciesForService(serviceId).then((policy) {
      return policy.first.toEntity();
    });
  }

  @override
  Future<void> syncPolicies() async {
    try {
      final policies = await remoteDatasource.fetchPoliciesFromNetwork();

      final policyIsar = policies.map((policy) => policy.toIsar()).toList();

      localDatasource.cachePolicies(policyIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<PolicyEntity> watchPolicyForService(String serviceId) {
    return localDatasource.watchCachedPoliciesForService(serviceId).map((policy) {
      return policy.first.toEntity();
    });
  }
}