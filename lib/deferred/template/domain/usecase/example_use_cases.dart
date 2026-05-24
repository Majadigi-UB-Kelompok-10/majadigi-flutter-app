// =============================================================================
// TEMPLATE: domain/usecase/{prefix}_use_cases.dart
// Replace {prefix}, {Prefix}, {Feature} with your module values.
// One file can contain ALL use cases for the module.
// =============================================================================

// TODO: Import entities and repository contract
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/entities/{feature}/{prefix}_{feature}_entity.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/domain/repositories/{prefix}_repository.dart';

// ---------------------------------------------------------------------------
// Read Use Cases
// ---------------------------------------------------------------------------

/// Fetch all {feature} items
// class Get{Feature}UseCase {
//   final {Prefix}Repository repository;
//   Get{Feature}UseCase(this.repository);
//
//   Future<List<{Prefix}{Feature}Entity>> execute() async {
//     return await repository.get{Feature}();
//   }
// }

/// Watch all {feature} items
// class Watch{Feature}UseCase {
//   final {Prefix}Repository repository;
//   Watch{Feature}UseCase(this.repository);
//
//   Stream<List<{Prefix}{Feature}Entity>> execute() {
//     return repository.watch{Feature}();
//   }
// }

// ---------------------------------------------------------------------------
// Sync Use Cases (SWR cache refresh)
// ---------------------------------------------------------------------------

/// Sync {feature} from remote to local cache
// class Sync{Feature}UseCase {
//   final {Prefix}Repository repository;
//   Sync{Feature}UseCase(this.repository);
//
//   Future<void> execute() async {
//     return await repository.sync{Feature}();
//   }
// }

// ---------------------------------------------------------------------------
// Search / Parameterized Use Cases
// ---------------------------------------------------------------------------

/// Search {feature} with parameters
// class Search{Feature}UseCase {
//   final {Prefix}Repository repository;
//   Search{Feature}UseCase(this.repository);
//
//   Future<List<{Prefix}{Feature}Entity>> execute({
//     required String param1,
//     required String param2,
//   }) async {
//     return await repository.search{Feature}(
//       param1: param1,
//       param2: param2,
//     );
//   }
// }
