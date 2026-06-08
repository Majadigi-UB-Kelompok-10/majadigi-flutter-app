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
  return GetAllCategoryForServiceUseCase(ref.watch(_categoryRepositoryProvider));
}

/// Save User Category Preferences
@riverpod
SaveUserCategoryPreferenceUseCase _saveUserCategoryPreferenceUseCase(Ref ref) {
  return SaveUserCategoryPreferenceUseCase(ref.watch(_categoryRepositoryProvider));
}

/// Get User Category Preferences
@riverpod
GetUserCategoryPreferenceUseCase _getUserCategoryPreferenceUseCase(Ref ref) {
  return GetUserCategoryPreferenceUseCase(ref.watch(_categoryRepositoryProvider));
}

// -- Exposed Use Case for Category --
/// Sync Category from Remote Datasource while Providing Stale Data
@riverpod
Stream<List<CategoryEntity>> categoryList(Ref ref) {
  final watchAllCategoryUseCase = ref.watch(_watchAllCategoryUseCaseProvider);

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

/// Save User Category Preferences (Passthrough)
@riverpod
Future<bool> saveUserCategoryPreferences(Ref ref, List<String> categoryIds) async {
  final saveUserCategoryPreferencesUseCase = ref.watch(
    _saveUserCategoryPreferenceUseCaseProvider
  );

  return await saveUserCategoryPreferencesUseCase.execute(categoryIds);
}

/// Get User Category Preferences (Passthrough)
@riverpod
Future<List<CategoryEntity>> getUserCategoryPreferences(Ref ref) async {
  final getUserCategoryPreferencesUseCase = ref.watch(
    _getUserCategoryPreferenceUseCaseProvider
  );

  return await getUserCategoryPreferencesUseCase.execute();
}

/// Clear User Category Preference (for logout use)
@riverpod
ClearUserCategoryPreferenceUseCase clearUserCategoryPreferenceUseCase(Ref ref) {
  return ClearUserCategoryPreferenceUseCase(ref.watch(_categoryRepositoryProvider));
}