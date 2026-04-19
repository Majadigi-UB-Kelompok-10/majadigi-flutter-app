import 'package:majadigi_mobile_rebuild/domain/repositories/policy_repository.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/policy/policy_entity.dart';

/// Watch Policy based on ServiceId
/// @return Stream<PolicyEntity>
class WatchPolicyForServiceUseCase {
  final PolicyRepository repository;

  WatchPolicyForServiceUseCase(this.repository);

  Stream<PolicyEntity> execute(String serviceId) {
    return repository.watchPolicyForService(serviceId);
  }
}

/// Sync Policy from remote datasource
/// @return void
class SyncPoliciesUseCase {
  final PolicyRepository repository;

  SyncPoliciesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncPolicies();
  }
}

/// Get Policy based on ServiceId
/// @return PolicyEntity
class GetPolicyForServiceUseCase {
  final PolicyRepository repository;

  GetPolicyForServiceUseCase(this.repository);

  Future<PolicyEntity> execute(String serviceId) async {
    return await repository.getPolicyForService(serviceId);
  }
}