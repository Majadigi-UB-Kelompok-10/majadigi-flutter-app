import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/integration/integration_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/integration/integration_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/integration_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/integration_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/integration_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'integration_providers.g.dart';

/// Local Datasource for Integration
@riverpod
IntegrationLocalDatasource _integrationLocalDatasource(Ref ref) {
  return IntegrationLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Integration
@riverpod
IntegrationRemoteDatasource _integrationRemoteDatasource(Ref ref) {
  return IntegrationRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider)
  );
}

/// Repository for Integration
@riverpod
IntegrationRepository integrationRepository(Ref ref) {
  return IntegrationRepositoryImpl(
    localDatasource: ref.watch(_integrationLocalDatasourceProvider),
    remoteDatasource: ref.watch(_integrationRemoteDatasourceProvider)
  );
}

// -- Implement Use Cases for Integration --
/// Watch Integration based on ServiceId (Streams)
@riverpod
WatchIntegrationsForServiceUseCase _watchIntegrationsForServiceUseCase(Ref ref) {
  return WatchIntegrationsForServiceUseCase(ref.watch(integrationRepositoryProvider));
}

/// Sync Integration from Remote Data Source
@riverpod
SyncIntegrationsUseCase syncIntegrationsUseCase(Ref ref) {
  return SyncIntegrationsUseCase(ref.watch(integrationRepositoryProvider));
}

/// Get List of Integration based on ServiceId
@riverpod
GetAllIntegrationsForServiceUseCase _getAllIntegrationsForServiceUseCase(Ref ref) {
  return GetAllIntegrationsForServiceUseCase(ref.watch(integrationRepositoryProvider));
}

// -- Exposed Use Cases for Integration --
/// Watch Integration based on ServiceId (Streams)
@riverpod
Stream<List<IntegrationEntity>> watchIntegrationsForService(Ref ref, String serviceId) {
  final watchIntegrationsForServiceUseCase = ref.watch(_watchIntegrationsForServiceUseCaseProvider);

  return watchIntegrationsForServiceUseCase.execute(serviceId);
}

/// Get List of Integrations based on ServiceId
@riverpod
Future<List<IntegrationEntity>?> getAllIntegrationsForService(Ref ref, String serviceId) async {
  final getAllIntegrationsForServiceUseCase = ref.watch(_getAllIntegrationsForServiceUseCaseProvider);

  return await getAllIntegrationsForServiceUseCase.execute(serviceId);
}