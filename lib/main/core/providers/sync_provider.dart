import 'package:flutter/material.dart' show debugPrint;
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/image/image_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/integration/integration_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/operational/operational_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/policy/policy_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/category/category_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/operational/operational_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'endpoint/endpoint_provider.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
class StartupSyncAll extends _$StartupSyncAll {

  // Required by Generator
  @override
  void build() {}

  Future<void> syncSilently() async {
    try {
      final syncServices = ref.read(syncServicesUseCaseProvider);
      final syncCategory = ref.read(syncCategoryUseCaseProvider);
      final syncIntegration = ref.read(syncIntegrationsUseCaseProvider);
      final syncOperational = ref.read(syncOperationalUseCaseProvider);
      final syncPolicy = ref.read(syncPoliciesUseCaseProvider);
      final syncImage = ref.read(syncImageUseCaseProvider);
      final syncFavorite = ref.read(syncFavoritesUseCaseProvider);
      final syncEndpoints = ref.read(syncEndpointsUseCaseProvider);

      Future<void> syncDependentChain() async {
        // These MUST happen in order
        await syncCategory.execute().timeout(const Duration(seconds: 20));
        await syncServices.execute().timeout(const Duration(seconds: 20));
        await syncFavorite.execute().timeout(const Duration(seconds: 20));
      }

      /// Sync category preferences: push local to remote as catch-up
      Future<void> syncCategoryPreferences() async {
        try {
          final getUserPrefs = ref.read(getUserCategoryPreferencesProvider.future);
          final prefs = await getUserPrefs;
          if (prefs.isNotEmpty) {
            final ids = prefs.map((c) => c.id!).toList();
            final saveUseCase = ref.read(saveUserCategoryPreferencesProvider(ids).future);
            await saveUseCase;
          }
        } catch (_) { /* Skip silently */ }
      }

      // 2. Run the chain in parallel with all independent tasks
      await Future.wait([
        syncDependentChain(), // This sequence takes up to 60s max
        syncIntegration.execute().timeout(const Duration(seconds: 20)),
        syncOperational.execute().timeout(const Duration(seconds: 20)),
        syncPolicy.execute().timeout(const Duration(seconds: 20)),
        syncImage.execute().timeout(const Duration(seconds: 20)),
        syncEndpoints.execute().timeout(const Duration(seconds: 20)),
        syncCategoryPreferences(),
      ]);

      debugPrint("Silent sync completed successfully.");
    } catch (e) {
      debugPrint("Silent sync failed or timed out: $e");
    }
  }
}

/// Sync with Visible Progress
@riverpod
SyncDatabaseService syncDatabaseService(Ref ref) {
  return SyncDatabaseService(ref);
}

class SyncDatabaseService {
  final Ref ref;

  SyncDatabaseService(this.ref);

  /// Sync with Visible Progress
  Stream<double> executeSync() async* {
    try {
      // You can safely read other providers here using the passed 'ref'
      final syncServices = ref.read(syncServicesUseCaseProvider);
      final syncCategory = ref.read(syncCategoryUseCaseProvider);
      final syncIntegration = ref.read(syncIntegrationsUseCaseProvider);
      final syncOperational = ref.read(syncOperationalUseCaseProvider);
      final syncPolicy = ref.read(syncPoliciesUseCaseProvider);
      final syncImage = ref.read(syncImageUseCaseProvider);
      final syncFavorite = ref.read(syncFavoritesUseCaseProvider);
      final syncEndpoints = ref.read(syncEndpointsUseCaseProvider);

      final double progressStep = 1 / 7;
      double progress = 0;

      await syncCategory.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      await syncServices.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      // Fire and Forget
      syncFavorite.execute().timeout(const Duration(seconds: 20));

      await syncIntegration.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      await syncOperational.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      await syncPolicy.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      await syncImage.execute().timeout(const Duration(seconds: 20));
      progress += progressStep;
      yield progress;

      await syncEndpoints.execute().timeout(const Duration(seconds: 20));
    } catch (e) {
      // Skip
      debugPrint("Silent sync failed or timed out: $e");
    } finally {
      yield 1.0;
    }
  }
}

/// Check count of data in Isar
@riverpod
Future<bool> isarDatabaseIsEmpty(Ref ref) async {
  final isar = ref.watch(isarProvider);

  // Mandatories
  final isServiceEmpty = await isar.isarServiceRegistrys.where().isEmpty();
  final isCategoryEmpty = await isar.isarCategoryRegistrys.where().isEmpty();
  final isOperationalEmpty = await isar.isarOperationalRegistrys.where().isEmpty();

  // Other collections is optional
  return isServiceEmpty || isCategoryEmpty || isOperationalEmpty;
}