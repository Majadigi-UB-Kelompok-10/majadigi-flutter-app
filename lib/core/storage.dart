import 'dart:io';
import 'package:majadigi_mobile_rebuild/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/endpoint/endpoint_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/policy/policy_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/operational/operational_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/integration/integration_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/image/image_registry.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> directory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@riverpod
Future<Isar> openIsar(Ref ref) async {
  final dir = await ref.read(directoryProvider.future);

  return await Isar.open(
      [
        IsarCategoryRegistrySchema,
        IsarServiceRegistrySchema,
        IsarPolicyRegistrySchema,
        IsarOperationalRegistrySchema,
        IsarIntegrationRegistrySchema,
        IsarImageRegistrySchema,
        IsarEndpointRegistrySchema
      ],
      directory: dir.path
  );
}

@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError('IsarProvider must be overridden');
}

@riverpod
Future<void> clearIsar(Ref ref) async {
  final isar = ref.read(isarProvider);
  isar.close(deleteFromDisk: true);
}

@riverpod
Future<void> clearAndRestartIsar(Ref ref) async {
  await ref.read(clearIsarProvider.future);
  ref.read(openIsarProvider);
}