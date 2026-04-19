import 'package:majadigi_mobile_rebuild/core/http.dart';
import 'package:majadigi_mobile_rebuild/core/storage.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/service/service_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/service/service_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/repositories/service_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/service_repository.dart';
import 'package:majadigi_mobile_rebuild/domain/usecase/service_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

/// Local Datasource for Service
@riverpod
ServiceLocalDatasource localDatasource(Ref ref) {
  return ServiceLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Service
@riverpod
ServiceRemoteDatasource remoteDatasource(Ref ref) {
  return ServiceRemoteDatasourceImpl(ref.watch(dioProvider));
}

/// Repository for Service
@riverpod
ServiceRepository serviceRepository(Ref ref) {
  return ServiceRepositoryImpl(
    localDatasource: ref.watch(localDatasourceProvider),
    remoteDatasource: ref.watch(remoteDatasourceProvider),
  );
}

// -- Implement Use Cases for Service --
/// Watch all services from Isar Database
@riverpod
WatchAllServicesUseCase watchAllServicesUseCase(Ref ref) {
  return WatchAllServicesUseCase(ref.watch(serviceRepositoryProvider));
}

/// Sync services from Remote Data Sources
@riverpod
SyncServicesUseCase syncServicesUseCase(Ref ref) {
  return SyncServicesUseCase(ref.watch(serviceRepositoryProvider));
}

// -- UI Facing Use Cases for Service --
/// Sync Services from Remote Datasource while Providing Stale Data
@riverpod
Stream<List<ServiceEntity>> serviceList(Ref ref) {
  final watchAllServicesUseCase = ref.watch(watchAllServicesUseCaseProvider);
  final syncServicesUseCase = ref.watch(syncServicesUseCaseProvider);

  // Sync database from network
  syncServicesUseCase.execute();

  // Watch from database
  return watchAllServicesUseCase.execute();
}