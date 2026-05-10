import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/service_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/service_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/service_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

// ! Warning: You should only use these after populating category table

/// Local Datasource for Service
@riverpod
ServiceLocalDatasource _serviceLocalDatasource(Ref ref) {
  return ServiceLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Service
@riverpod
ServiceRemoteDatasource _serviceRemoteDatasource(Ref ref) {
  return ServiceRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

/// Repository for Service
@riverpod
ServiceRepository _serviceRepository(Ref ref) {
  return ServiceRepositoryImpl(
    localDatasource: ref.watch(_serviceLocalDatasourceProvider),
    remoteDatasource: ref.watch(_serviceRemoteDatasourceProvider),
  );
}

// -- Implement Use Cases for Service --
/// Watch all services from Isar Database
@riverpod
WatchAllServicesUseCase _watchAllServicesUseCase(Ref ref) {
  return WatchAllServicesUseCase(ref.watch(_serviceRepositoryProvider));
}

/// Sync services from Remote Data Sources
@riverpod
SyncServicesUseCase syncServicesUseCase(Ref ref) {
  return SyncServicesUseCase(ref.watch(_serviceRepositoryProvider));
}

/// Get all services in a specific category as a List<ServiceEntity>
@riverpod
GetAllServicesInCategoryUseCase _getAllServicesInCategoryUseCase(Ref ref) {
  return GetAllServicesInCategoryUseCase(ref.watch(_serviceRepositoryProvider));
}

// -- Exposed Use Cases for Service --
/// Sync Services from Remote Datasource while Providing Stale Data
@riverpod
Stream<List<ServiceEntity>> serviceList(Ref ref) {
  final watchAllServicesUseCase = ref.watch(_watchAllServicesUseCaseProvider);

  // Watch from database
  return watchAllServicesUseCase.execute();
}

/// Get all services in a specific category as a List<ServiceEntity> (Passthrough)
@riverpod
Future<List<ServiceEntity>> getAllServicesInCategory(
  Ref ref,
  String categoryId,
) async {
  final getAllServicesInCategoryUseCase = ref.watch(
    _getAllServicesInCategoryUseCaseProvider,
  );

  return await getAllServicesInCategoryUseCase.execute(categoryId);
}
