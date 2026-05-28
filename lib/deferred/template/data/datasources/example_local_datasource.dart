// =============================================================================
// TEMPLATE: data/datasources/{prefix}_local_datasource.dart
// Replace {prefix}, {Prefix}, {Feature}, {module_name} with your module values.
// Abstract contract + implementation in the same file.
// =============================================================================

// TODO: Import Isar registry classes
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/models/isar/{feature}/{prefix}_{feature}_registry.dart';

/// Contract for this module's local data source.
/// Uses Isar Database (separate instance from main).
// abstract class {Prefix}LocalDatasource {
//   // {Feature}
//   Future<List<Isar{Prefix}{Feature}Registry>> getCached{Feature}();
//   Stream<List<Isar{Prefix}{Feature}Registry>> watchCached{Feature}();
//   Future<void> cache{Feature}(List<Isar{Prefix}{Feature}Registry> items);
//
//   // TODO: Add more CRUD methods per feature
//   // Future<Isar{Prefix}{Feature}Registry?> getCached{Feature}ById(int id);
//   // Future<List<Isar{Prefix}{Feature}Registry>> searchCached{Feature}({required String query});
// }

/// Implementation using Isar database.
// class {Prefix}LocalDatasourceImpl implements {Prefix}LocalDatasource {
//   final Isar _isar;
//   {Prefix}LocalDatasourceImpl(this._isar);
//
//   // -- {Feature} --
//
//   @override
//   Future<List<Isar{Prefix}{Feature}Registry>> getCached{Feature}() {
//     return _isar.isar{Prefix}{Feature}Registrys.where().findAll();
//   }
//
//   @override
//   Future<void> cache{Feature}(List<Isar{Prefix}{Feature}Registry> items) async {
//     await _isar.writeTxn(() async {
//       await _isar.isar{Prefix}{Feature}Registrys.clear();
//       await _isar.isar{Prefix}{Feature}Registrys.putAllBy{Index}(items);
//     });
//   }
//
//   @override
//   Stream<List<Isar{Prefix}{Feature}Registry>> watchCached{Feature}() {
//     return _isar.isar{Prefix}{Feature}Registrys.where().watch(fireImmediately: true);
//   }
// }
