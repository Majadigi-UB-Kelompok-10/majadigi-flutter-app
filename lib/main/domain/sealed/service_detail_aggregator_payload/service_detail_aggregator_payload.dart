import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/operational/operational_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/policy/policy_entity.dart';

part 'service_detail_aggregator_payload.freezed.dart';

/// Represent Payload Sealed Class
@freezed
sealed class ServiceDetailAggregatorPayload with _$ServiceDetailAggregatorPayload {}

/// Represent Integration Payload
@freezed
class IntegrationPayload extends ServiceDetailAggregatorPayload with _$IntegrationPayload {
  @override
  final List<IntegrationEntity> data;

  IntegrationPayload(this.data);
}

/// Represent Operational Payload
@freezed
class OperationalPayload extends ServiceDetailAggregatorPayload with _$OperationalPayload {
  @override
  final OperationalEntity data;

  OperationalPayload(this.data);
}

/// Represent Integration Payload
@freezed
class PolicyPayload extends ServiceDetailAggregatorPayload with _$PolicyPayload {
  @override
  final PolicyEntity data;

  PolicyPayload(this.data);
}