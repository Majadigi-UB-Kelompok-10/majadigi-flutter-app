// =============================================================================
// TEMPLATE: core/storage.dart
// Replace {prefix}, {Prefix}, {module_name} with your module values.
// Register ALL Isar schemas from data/models/isar/ in the schema list.
// =============================================================================

import 'dart:io';
import 'package:isar_community/isar.dart';
// TODO: Import all Isar registry schemas from data/models/isar/{feature}/
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/data/models/isar/{feature}/{prefix}_{feature}_registry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'storage.g.dart';

/// Return the application documents directory
// @riverpod
// Future<Directory> {prefix}Directory(Ref ref) async {
//   return await getApplicationDocumentsDirectory();
// }

/// This module's own Isar instance — lazily self-initializes on first access.
/// Uses keepAlive so the instance persists once opened and is never
/// garbage-collected for the lifetime of the app session.
// @Riverpod(keepAlive: true)
// Future<Isar> {prefix}Isar(Ref ref) async {
//   final dir = await ref.read({prefix}DirectoryProvider.future);
//
//   return await Isar.open(
//     [
//       // TODO: List all Isar schemas for this module
//       // Isar{Prefix}{Feature}RegistrySchema,
//     ],
//     directory: dir.path,
//     name: '{module_name}', // Must be unique across all deferred modules
//   );
// }
