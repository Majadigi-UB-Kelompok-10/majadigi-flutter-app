import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/endpoint/endpoint_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/favorites/favorite_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/profile/profile_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/policy/policy_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/operational/operational_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/integration/integration_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/image/image_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/etag/etag_registry.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'storage.g.dart';

@riverpod
Future<Directory> directory(Ref ref) async {
  return await getApplicationDocumentsDirectory();
}

@riverpod
Future<Isar> openIsar(Ref ref) async {
  final dir = await ref.read(directoryProvider.future);

  return await Isar.open([
    IsarProfileRegistrySchema,
    IsarFavoriteRegistrySchema,
    IsarCategoryRegistrySchema,
    IsarServiceRegistrySchema,
    IsarPolicyRegistrySchema,
    IsarOperationalRegistrySchema,
    IsarIntegrationRegistrySchema,
    IsarImageRegistrySchema,
    IsarEndpointRegistrySchema,
    IsarEtagRegistrySchema,
  ], directory: dir.path);
}

@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError('IsarProvider must be overridden');
}

@riverpod
Future<void> clearIsar(Ref ref) async {
  final isar = ref.read(isarProvider);
  await isar.close(deleteFromDisk: true);
}

@riverpod
Future<void> clearAndRestartIsar(Ref ref) async {
  await ref.read(clearIsarProvider.future);
  ref.read(openIsarProvider);
}

@riverpod
CacheManager getCustomCacheManager(Ref ref) {
  return CacheManager(
    Config(
      'Majadigi-Assets',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100
    ),
  );
}

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// Constants for Secure Storage
class SecureStorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenType = 'token_type';
  static const String guestMode = 'guest_mode';
}
