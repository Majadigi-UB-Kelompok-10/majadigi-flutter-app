import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/policy/policy_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/policy/policy_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/policy_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/policy/policy_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/policy_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/policy_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'policy_providers.g.dart';

/// Local Datasource for Policy
@riverpod
PolicyLocalDatasource _policyLocalDatasource(Ref ref) {
  return PolicyLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Policy
@riverpod
PolicyRemoteDatasource _policyRemoteDatasource(Ref ref) {
  return PolicyRemoteDatasourceImpl(
      dio: ref.watch(dioProvider),
      zstandard: ref.watch(zstandardProvider)
  );
}

/// Repository for Policy
@riverpod
PolicyRepository policyRepository(Ref ref) {
  return PolicyRepositoryImpl(
      localDatasource: ref.watch(_policyLocalDatasourceProvider),
      remoteDatasource: ref.watch(_policyRemoteDatasourceProvider)
  );
}

// -- Implement Use Cases for Policy --
/// Watch Policie based on ServiceId (Streams)
@riverpod
WatchPolicyForServiceUseCase _watchPolicyForServiceUseCase(Ref ref) {
  return WatchPolicyForServiceUseCase(ref.watch(policyRepositoryProvider));
}

/// Sync Policie from Remote Data Source
@riverpod
SyncPoliciesUseCase syncPoliciesUseCase(Ref ref) {
  return SyncPoliciesUseCase(ref.watch(policyRepositoryProvider));
}

/// Get List of Policy based on ServiceId
@riverpod
GetPolicyForServiceUseCase _getPolicyForServiceUseCase(Ref ref) {
  return GetPolicyForServiceUseCase(ref.watch(policyRepositoryProvider));
}

// -- Exposed Use Cases for Policy --
/// Watch Policy based on ServiceId (Streams)
@riverpod
Stream<PolicyEntity> watchPolicyForService(Ref ref, String serviceId) {
  final watchPolicyForServiceUseCase = ref.watch(_watchPolicyForServiceUseCaseProvider);

  return watchPolicyForServiceUseCase.execute(serviceId);
}

/// Get List of Policys based on ServiceId
@riverpod
Future<PolicyEntity?> getPolicyForService(Ref ref, String serviceId) async {
  final getPolicyForServiceUseCase = ref.watch(_getPolicyForServiceUseCaseProvider);

  return await getPolicyForServiceUseCase.execute(serviceId);
}