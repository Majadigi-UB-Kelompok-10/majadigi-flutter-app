import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/integration_list/integration_list_notifier.dart';
import 'package:majadigi_mobile/data/services/supabase/operational_list/operational_list_notifier.dart';
import 'package:majadigi_mobile/data/services/supabase/policy_list/policy_list_notifier.dart';
import 'package:majadigi_mobile/domain/sealed_type/tab_payload.dart';

/*
 * Data will be returned like this:
 * Map<int, Map<String, List<dynamic>>>
 *
 * Key (int) is for choice chip index
 * Value (Map) contains the choice chip title as key
 * and the relevant List Data
 */
// ? Aggregated Data Provider
final aggregatedServicePageDataMiddlewareProvider = Provider.autoDispose.family<
  AsyncValue<Map<int, Map<String, TabPayload>>>,
  String
>((ref, serviceListId) {
  final integrationList = ref.watch(integrationListProvider(serviceListId));
  final operationalList = ref.watch(operationalListProvider(serviceListId));
  final policyList = ref.watch(policyListProvider(serviceListId));

  // Handle loading state
  if (integrationList.isLoading && !integrationList.hasValue ||
      operationalList.isLoading && !operationalList.hasValue ||
      policyList.isLoading && !policyList.hasValue) {
    return const AsyncLoading();
  }

  // Handle Errors
  if (integrationList.hasError) return AsyncError(integrationList.error!, integrationList.stackTrace!);
  if (operationalList.hasError) return AsyncError(operationalList.error!, operationalList.stackTrace!);
  if (policyList.hasError) return AsyncError(policyList.error!, policyList.stackTrace!);

  // Prepare Payload
  Map<int, Map<String, TabPayload>> result = {};
  int index = 0;
  if (integrationList.hasValue && integrationList.value!.isNotEmpty) {
    result.putIfAbsent(index, () => {
      'Layanan': IntegrationPayload(integrationList.value!)
    });

    index++;
  }

  if (operationalList.hasValue && operationalList.value!.isNotEmpty) {
    result.putIfAbsent(index, () => {
      'Operasional': OperationalPayload(operationalList.value!)
    });

    index++;
  }

  if (policyList.hasValue && policyList.value!.isNotEmpty) {
    result.putIfAbsent(index, () => {
      'Ketentuan Umum': PolicyPayload(policyList.value!)
    });

    index++;
  }

  return AsyncData(result);
});

// ? Async Notifier Provider
// final genericServicePageDataMiddlewareProvider = AsyncNotifierProvider.autoDispose.family<
//     GenericServicePageDataMiddleware,
//     Map<int, Map<String, TabPayload>>,
//     String
// >(GenericServicePageDataMiddleware.new);

// ? Async Notifier as Middleware
// class GenericServicePageDataMiddleware extends AsyncNotifier<Map<int, Map<String, TabPayload>>> {
//   final String serviceListId;
//   GenericServicePageDataMiddleware(this.serviceListId);
//
//   @override
//   Future<Map<int, Map<String, TabPayload>>> build() async {
//     final integrationList = await ref.watch(integrationListProvider(serviceListId).future);
//     final operationalList = await ref.watch(operationalListProvider(serviceListId).future);
//     final policyList = await ref.watch(policyListProvider(serviceListId).future);
//
//     // Create an object and index to prepare
//     Map<int, Map<String, TabPayload>> result = {};
//     int index = 0;
//
//     // Add to map if NOT empty
//     if (integrationList.isNotEmpty) {
//       result.putIfAbsent(index, () => {
//         'Layanan': IntegrationPayload(integrationList)
//       });
//
//       index++;
//     }
//
//     if (operationalList.isNotEmpty) {
//       result.putIfAbsent(index, () => {
//         'Operasional': OperationalPayload(operationalList)
//       });
//
//       index++;
//     }
//
//     if (policyList.isNotEmpty) {
//       result.putIfAbsent(index, () => {
//         'Ketentuan Umum': PolicyPayload(policyList)
//       });
//
//       index++;
//     }
//
//     return result;
//   }
// }