import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/isar/bansos/bansos_registry.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> bansosDirectory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@Riverpod(keepAlive: true)
Future<Isar> bansosIsar(Ref ref) async {
  final dir = await ref.read(bansosDirectoryProvider.future);

  return await Isar.open(
    [
      IsarBansosRegistrySchema,
    ],
    directory: dir.path,
    name: 'bansos',
  );
}
