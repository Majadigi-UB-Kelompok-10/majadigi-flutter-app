import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/isar/summary/rssa_summary_registry.dart';
import '../data/models/isar/kelas/rssa_kelas_registry.dart';
import '../data/models/isar/ruangan/rssa_ruangan_registry.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> rssaDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@Riverpod(keepAlive: true)
Future<Isar> rssaIsarDb(Ref ref) async {
  final dir = await ref.watch(rssaDirectoryProvider.future);
  
  if (Isar.getInstance('rssa') != null) {
    return Isar.getInstance('rssa')!;
  }
  
  return await Isar.open(
    [
      IsarRssaSummaryRegistrySchema,
      IsarRssaKelasRegistrySchema,
      IsarRssaRuanganRegistrySchema,
    ],
    directory: dir.path,
    name: 'rssa', // Must be unique across all deferred modules
  );
}

@riverpod
Future<void> rssaClearIsarDb(Ref ref) async {
  final isar = await ref.watch(rssaIsarDbProvider.future);

  if (Isar.getInstance('rssa') != null) {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
