import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/operational/operational_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/policy/policy_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/integration_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/operational_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/policy_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/sealed/service_detail_aggregator_payload/service_detail_aggregator_payload.dart';

/// Get Aggregated Integration, Operational, and Policy List
class GetAggregatedServiceUseCase {
  final IntegrationRepository integrationRepository;
  final OperationalRepository operationalRepository;
  final PolicyRepository policyRepository;

  const GetAggregatedServiceUseCase({
    required this.integrationRepository,
    required this.operationalRepository,
    required this.policyRepository
  });

  Future<Map<int, Map<String, ServiceDetailAggregatorPayload>>> execute(String serviceId) async {
    List<IntegrationEntity>? integrationList = await integrationRepository.getAllIntegrationForService(serviceId);
    OperationalEntity? operationalEntity = await operationalRepository.getOperationalForService(serviceId);
    PolicyEntity? policyEntity = await policyRepository.getPolicyForService(serviceId);

    // Prepare payload
    Map<int, Map<String, ServiceDetailAggregatorPayload>> result = {};
    int index = 0;

    if (integrationList != null && integrationList.isNotEmpty) {
      result.putIfAbsent(index, () => {
        'Layanan': IntegrationPayload(integrationList)
      });

      index++;
    }

    if (operationalEntity != null) {
      result.putIfAbsent(index, () => {
        'Operasional': OperationalPayload(operationalEntity)
      });
      
      index++;
    }

    if (policyEntity != null) {
      result.putIfAbsent(index, () => {
        'Ketentuan Umum': PolicyPayload(policyEntity)
      });

      index++;
    }

    return result;
  }
}