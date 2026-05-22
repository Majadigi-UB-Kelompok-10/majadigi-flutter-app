import 'package:majadigi_mobile_rebuild/main/core/providers/integration/integration_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/operational/operational_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/policy/policy_providers.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/integration_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/operational_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/policy_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/service_detail_aggregator_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:majadigi_mobile_rebuild/main/domain/sealed/service_detail_aggregator_payload/service_detail_aggregator_payload.dart';

part 'service_detail_provider.g.dart';

// -- Exposed Use Case for Service Detail --
/// Get Service Detail Aggregated Payload
@riverpod
Future<Map<int, Map<String, ServiceDetailAggregatorPayload>>> serviceDetailPayload(Ref ref, String serviceId) async {
  IntegrationRepository integrationRepository = ref.watch(integrationRepositoryProvider);
  OperationalRepository operationalRepository = ref.watch(operationalRepositoryProvider);
  PolicyRepository policyRepository = ref.watch(policyRepositoryProvider);

  return await GetAggregatedServiceUseCase(
    integrationRepository: integrationRepository,
    operationalRepository: operationalRepository,
    policyRepository: policyRepository
  ).execute(serviceId);
}