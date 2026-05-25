// =============================================================================
// TEMPLATE: core/providers/{prefix}_providers.dart
// Replace {prefix}, {Prefix}, {module_name}, {Feature} with your module values.
// This single file wires: Datasources → Repository → UseCases → Exposed Data.
// =============================================================================

// TODO: Update imports to match your module
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/entities/{feature}/{prefix}_{feature}_entity.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/core/storage.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/datasources/{prefix}_local_datasource.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/datasources/{prefix}_remote_datasource.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/repositories/{prefix}_repository_impl.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/repositories/{prefix}_repository.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/usecase/{prefix}_use_cases.dart';

// part '{prefix}_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

/// Local Datasource — uses module's own Isar instance.
/// Async because Isar is lazily initialized on first access.
// @riverpod
// Future<{Prefix}LocalDatasource> _{prefix}LocalDatasource(Ref ref) async {
//   final isar = await ref.watch({prefix}IsarProvider.future);
//   return {Prefix}LocalDatasourceImpl(isar);
// }

/// Remote Datasource — uses shared Dio & Zstandard from main.
// @riverpod
// {Prefix}RemoteDatasource _{prefix}RemoteDatasource(Ref ref) {
//   return {Prefix}RemoteDatasourceImpl(
//     dio: ref.watch(dioProvider),
//     zstandard: ref.watch(zstandardProvider),
//   );
// }

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

// @riverpod
// Future<{Prefix}Repository> _{prefix}Repository(Ref ref) async {
//   final localDatasource = await ref.watch(_{prefix}LocalDatasourceProvider.future);
//   final remoteDatasource = ref.watch(_{prefix}RemoteDatasourceProvider);
//   return {Prefix}RepositoryImpl(
//     localDatasource: localDatasource,
//     remoteDatasource: remoteDatasource,
//   );
// }

// ---------------------------------------------------------------------------
// Use Cases (private — one per action)
// ---------------------------------------------------------------------------

// @riverpod
// Future<Get{Feature}UseCase> _get{Feature}UseCase(Ref ref) async {
//   final repo = await ref.watch(_{prefix}RepositoryProvider.future);
//   return Get{Feature}UseCase(repo);
// }

// @riverpod
// Stream<Watch{Feature}UseCase> _watch{Feature}UseCase(Ref ref) async {
//   final repo = await ref.watch(_{prefix}RepositoryProvider.future);
//   return Watch{Feature}UseCase(repo);
// }

// @riverpod
// Future<Sync{Feature}UseCase> sync{Feature}UseCase(Ref ref) async {
//   final repo = await ref.watch(_{prefix}RepositoryProvider.future);
//   return Sync{Feature}UseCase(repo);
// }

// ---------------------------------------------------------------------------
// Exposed Data Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

// /// Get all {feature} items
// @riverpod
// Future<List<{Prefix}{Feature}Entity>> {prefix}{Feature}(Ref ref) async {
//   final useCase = await ref.watch(_get{Feature}UseCaseProvider.future);
//   return await useCase.execute();
// }

// /// Watch all {feature} items
// @riverpod
// Stream<List<{Prefix}{Feature}Entity>> {prefix}{Feature}(Ref ref) {
//   final useCase = await ref.watch(_watch{Feature}UseCaseProvider.future);
//   return useCase.execute();
// }
