import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/isar/area/skp_area_registry.dart';
import '../data/models/isar/bahan_pokok/skp_bahan_pokok_registry.dart';
import '../data/models/isar/bahan_pokok/skp_detail_bahan_pokok_registry.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> skpDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}
//

@Riverpod(keepAlive: true)
Future<Isar> skpIsarDb(Ref ref) async {
  final dir = await ref.watch(skpDirectoryProvider.future);
  
  if (Isar.getInstance('siskaperbapo') != null) {
    return Isar.getInstance('siskaperbapo')!;
  }
  
  return await Isar.open(
    [
      IsarSkpAreaRegistrySchema,
      IsarSkpBahanPokokRegistrySchema,
      IsarSkpDetailBahanPokokRegistrySchema,
    ],
    directory: dir.path,
    name: 'siskaperbapo',
  );
}

@riverpod
Future<void> skpClearIsarDb(Ref ref) async {
  final isar = await ref.watch(skpIsarDbProvider.future);

  if (Isar.getInstance('siskaperbapo') != null) {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
