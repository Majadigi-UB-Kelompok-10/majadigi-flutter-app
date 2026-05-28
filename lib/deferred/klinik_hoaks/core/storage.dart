import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/isar/stat/kh_stat_registry.dart';
import '../data/models/isar/news/kh_news_registry.dart';
import '../data/models/isar/news/kh_news_detail_registry.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> khDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@Riverpod(keepAlive: true)
Future<Isar> khIsarDb(Ref ref) async {
  final dir = await ref.watch(khDirectoryProvider.future);

  if (Isar.getInstance('klinik_hoaks') != null) {
    return Isar.getInstance('klinik_hoaks')!;
  }

  return await Isar.open(
    [
      IsarKhStatRegistrySchema,
      IsarKhNewsRegistrySchema,
      IsarKhNewsDetailRegistrySchema,
    ],
    directory: dir.path,
    name: 'klinik_hoaks',
  );
}

@riverpod
Future<void> khClearIsarDb(Ref ref) async {
  final isar = await ref.watch(khIsarDbProvider.future);

  if (Isar.getInstance('klinik_hoaks') != null) {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
