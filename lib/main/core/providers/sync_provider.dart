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

part 'sync_provider.g.dart';

@riverpod
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

      await syncServices.execute().timeout(const Duration(seconds: 20));
      await syncCategory.execute().timeout(const Duration(seconds: 20));
      await syncIntegration.execute().timeout(const Duration(seconds: 20));
      await syncOperational.execute().timeout(const Duration(seconds: 20));
      await syncPolicy.execute().timeout(const Duration(seconds: 20));
      await syncImage.execute().timeout(const Duration(seconds: 20));
    } catch (e) {
      print("Silent sync failed or timed out: $e");
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

      await syncServices.execute().timeout(const Duration(seconds: 20));
      yield 0.1;

      await syncCategory.execute().timeout(const Duration(seconds: 20));
      yield 0.3;

      await syncIntegration.execute().timeout(const Duration(seconds: 20));
      yield 0.5;

      await syncOperational.execute().timeout(const Duration(seconds: 20));
      yield 0.7;

      await syncPolicy.execute().timeout(const Duration(seconds: 20));
      yield 0.85;

      await syncImage.execute().timeout(const Duration(seconds: 20));
      yield 1.0;
    } catch (e) {
      // Skip
      yield 1.0;
      print("Silent sync failed or timed out: $e");
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