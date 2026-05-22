import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/operational/operational_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/operational/operational_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/operational_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/operational/operational_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/operational_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/operational_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operational_providers.g.dart';

/// Local Datasource for Operational
@riverpod
OperationalLocalDatasource _operationalLocalDatasource(Ref ref) {
  return OperationalLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Operational
@riverpod
OperationalRemoteDatasource _operationalRemoteDatasource(Ref ref) {
  return OperationalRemoteDatasourceImpl(
      dio: ref.watch(dioProvider),
      zstandard: ref.watch(zstandardProvider)
  );
}

/// Repository for Operational
@riverpod
OperationalRepository operationalRepository(Ref ref) {
  return OperationalRepositoryImpl(
      localDatasource: ref.watch(_operationalLocalDatasourceProvider),
      remoteDatasource: ref.watch(_operationalRemoteDatasourceProvider)
  );
}

// -- Implement Use Cases for Operational --
/// Watch Operational based on ServiceId (Streams)
@riverpod
WatchOperationalForServiceUseCase _watchOperationalForServiceUseCase(Ref ref) {
  return WatchOperationalForServiceUseCase(ref.watch(operationalRepositoryProvider));
}

/// Sync Operational from Remote Data Source
@riverpod
SyncOperationalsUseCase syncOperationalUseCase(Ref ref) {
  return SyncOperationalsUseCase(ref.watch(operationalRepositoryProvider));
}

/// Get List of Operational based on ServiceId
@riverpod
GetOperationalForServiceUseCase _getOperationalForServiceUseCase(Ref ref) {
  return GetOperationalForServiceUseCase(ref.watch(operationalRepositoryProvider));
}

// -- Exposed Use Cases for Operational --
/// Watch Operational based on ServiceId (Streams)
@riverpod
Stream<OperationalEntity?> watchOperationalsForService(Ref ref, String serviceId) {
  final watchOperationalsForServiceUseCase = ref.watch(_watchOperationalForServiceUseCaseProvider);

  return watchOperationalsForServiceUseCase.execute(serviceId);
}

/// Get List of Operational based on ServiceId
@riverpod
Future<OperationalEntity?> getOperationalForService(Ref ref, String serviceId) async {
  final getOperationalForServiceUseCase = ref.watch(_getOperationalForServiceUseCaseProvider);

  return await getOperationalForServiceUseCase.execute(serviceId);
}