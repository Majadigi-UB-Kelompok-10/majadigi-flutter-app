// =============================================================================
// TEMPLATE: data/repositories/{prefix}_repository_impl.dart
// Replace {prefix}, {Prefix}, {Feature}, {module_name} with your module values.
// =============================================================================

// TODO: Import datasources, models, entities, and domain contract
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/datasources/{prefix}_local_datasource.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/datasources/{prefix}_remote_datasource.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/models/isar/{feature}/{prefix}_{feature}_registry.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/models/dto/{feature}/{feature}_dto.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/entities/{feature}/{prefix}_{feature}_entity.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/repositories/{prefix}_repository.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// These keep DTOs untouched per project rules while providing clean conversion.
// Place ALL DTO→Isar extensions at the top of this file.
// ---------------------------------------------------------------------------

// extension {Feature}DtoToIsar on {Feature}Dto {
//   Isar{Prefix}{Feature}Registry toIsar() {
//     return Isar{Prefix}{Feature}Registry()
//       ..id = id
//       ..name = name
//       ..isActive = isActive;
//   }
// }

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

// class {Prefix}RepositoryImpl implements {Prefix}Repository {
//   final {Prefix}LocalDatasource localDatasource;
//   final {Prefix}RemoteDatasource remoteDatasource;
//
//   {Prefix}RepositoryImpl({
//     required this.localDatasource,
//     required this.remoteDatasource,
//   });
//
//   // -- {Feature} (SWR pattern) --
//
//   @override
//   Future<List<{Prefix}{Feature}Entity>> get{Feature}() async {
//     // do NOT Fire and forget for get unless for watches
//     await sync{Feature}();
//
//     // Return cached data immediately
//     final cached = await localDatasource.getCached{Feature}();
//     return cached.map((r) => r.toEntity()).toList();
//   }
//
//   @override
//   Future<void> sync{Feature}() async {
//     try {
//       final dtos = await remoteDatasource.fetch{Feature}();
//       if (dtos == null) return;
//
//       final registries = dtos.map((d) => d.toIsar()).toList();
//       await localDatasource.cache{Feature}(registries);
//     } catch (e) { /* Silently fail — cached data still available */ }
//   }
// }
//
// @override
// Stream<List<{Prefix}{Feature}Entity>> watch{Feature}() {
//   // Fire and Forget
//   sync{Feature}();
//
//   // return the list
//   return localDatasource.watchCached{Feature}().map(({FeatureData}) {
//     return {FeatureData}.map(({Data}) => {Data}.toEntity()).toList();
//   });
// }
