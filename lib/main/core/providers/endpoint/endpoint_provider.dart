import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/endpoint/endpoint_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/endpoint/endpoint_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/endpoint_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/endpoint/endpoint_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/endpoint_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/endpoint_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'endpoint_provider.g.dart';

/// Local Datasource for Endpoint
@riverpod
EndpointLocalDatasource _endpointLocalDatasource(Ref ref) {
  return EndpointLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Endpoint
@riverpod
EndpointRemoteDatasource _endpointRemoteDatasource(Ref ref) {
  return EndpointRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

/// Repository for Endpoint
@riverpod
EndpointRepository endpointRepository(Ref ref) {
  return EndpointRepositoryImpl(
    localDatasource: ref.watch(_endpointLocalDatasourceProvider),
    remoteDatasource: ref.watch(_endpointRemoteDatasourceProvider),
  );
}

// -- Implement Use Cases for Endpoint --

/// Get Endpoint based on IntegrationId
@riverpod
GetEndpointForIntegrationUseCase _getEndpointForIntegrationUseCase(Ref ref) {
  return GetEndpointForIntegrationUseCase(ref.watch(endpointRepositoryProvider));
}

/// Watch Endpoint based on IntegrationId (Streams)
@riverpod
WatchEndpointForIntegrationUseCase _watchEndpointForIntegrationUseCase(Ref ref) {
  return WatchEndpointForIntegrationUseCase(ref.watch(endpointRepositoryProvider));
}

/// Sync Endpoints from Remote Data Source
@riverpod
SyncEndpointsUseCase syncEndpointsUseCase(Ref ref) {
  return SyncEndpointsUseCase(ref.watch(endpointRepositoryProvider));
}

// -- Exposed Use Cases for Endpoint --

/// Get Endpoint based on IntegrationId
@riverpod
Future<EndpointEntity> getEndpointForIntegration(Ref ref, String integrationId) async {
  final getEndpointForIntegrationUseCase = ref.watch(_getEndpointForIntegrationUseCaseProvider);

  return await getEndpointForIntegrationUseCase.execute(integrationId);
}

/// Watch Endpoint based on IntegrationId (Streams)
@riverpod
Stream<EndpointEntity?> watchEndpointForIntegration(Ref ref, String integrationId) {
  final watchEndpointForIntegrationUseCase = ref.watch(_watchEndpointForIntegrationUseCaseProvider);

  return watchEndpointForIntegrationUseCase.execute(integrationId);
}
