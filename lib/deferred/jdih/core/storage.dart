import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/isar/pengumuman/jd_pengumuman_registry.dart';
import '../data/models/isar/filter/jd_jenis_filter_registry.dart';

part 'storage.g.dart';

/// Return the application documents directory
@riverpod
Future<Directory> jdDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

/// JDIH's own Isar instance — lazily self-initializes on first access.
/// Uses keepAlive so the instance persists once opened and is never
/// garbage-collected for the lifetime of the app session.
@Riverpod(keepAlive: true)
Future<Isar> jdIsar(Ref ref) async {
  final dir = await ref.read(jdDirectoryProvider.future);

  return await Isar.open(
    [
      IsarJdPengumumanRegistrySchema,
      IsarJdJenisFilterRegistrySchema,
    ],
    directory: dir.path,
    name: 'jdih',
  );
}
