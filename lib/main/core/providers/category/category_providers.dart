import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/category/category_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/category/category_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/category_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/category_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/category_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

/// Local Datasource for Category
@riverpod
CategoryLocalDatasource _categoryLocalDatasource(Ref ref) {
  return CategoryLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Category
@riverpod
CategoryRemoteDatasource _categoryRemoteDatasource(Ref ref) {
  return CategoryRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

/// Repository for Category
@riverpod
CategoryRepository _categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(
    localDatasource: ref.watch(_categoryLocalDatasourceProvider),
    remoteDatasource: ref.watch(_categoryRemoteDatasourceProvider),
  );
}

// -- Implement Use Cases for Category --
/// Watch all categories from Isar Database
@riverpod
WatchAllCategoryUseCase _watchAllCategoryUseCase(Ref ref) {
  return WatchAllCategoryUseCase(ref.watch(_categoryRepositoryProvider));
}

/// Sync categories from Remote Data Sources
@riverpod
SyncCategoryUseCase syncCategoryUseCase(Ref ref) {
  return SyncCategoryUseCase(ref.watch(_categoryRepositoryProvider));
}

/// Get all categories in a specific service as a List\<CategoryEntity\>
@riverpod
GetAllCategoryForServiceUseCase _getAllCategoryForServiceUseCase(Ref ref) {
  return GetAllCategoryForServiceUseCase(
    ref.watch(_categoryRepositoryProvider),
  );
}

// -- Exposed Use Case for Category --
/// Sync Category from Remote Datasource while Providing Stale Data
@riverpod
Stream<List<CategoryEntity>> categoryList(Ref ref) {
  final watchAllCategoryUseCase = ref.watch(_watchAllCategoryUseCaseProvider);
  final syncCategoryUseCase = ref.watch(syncCategoryUseCaseProvider);

  // Sync database from network
  syncCategoryUseCase.execute();

  // Watch from database
  return watchAllCategoryUseCase.execute();
}

/// Get all categories in a specific service as a List<CategoryEntity> (Passthrough)
@riverpod
Future<List<CategoryEntity>> getAllCategoryForService(
  Ref ref,
  String serviceId,
) async {
  final getAllCategoryForServiceUseCase = ref.watch(
    _getAllCategoryForServiceUseCaseProvider,
  );

  return await getAllCategoryForServiceUseCase.execute(serviceId);
}
