import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/isar/blk/snk_blk_registry.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> snkDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@Riverpod(keepAlive: true)
Future<Isar> snkIsarDb(Ref ref) async {
  final dir = await ref.watch(snkDirectoryProvider.future);

  if (Isar.getInstance('sinaker') != null) {
    return Isar.getInstance('sinaker')!;
  }

  return await Isar.open(
    [
      IsarSnkBlkRegistrySchema,
    ],
    directory: dir.path,
    name: 'sinaker',
  );
}
