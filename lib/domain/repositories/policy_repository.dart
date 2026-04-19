import 'package:majadigi_mobile_rebuild/domain/entities/policy/policy_entity.dart';

/// Represent Contract for Policies
abstract class PolicyRepository {
  Future<PolicyEntity> getPolicyForService(String serviceId);
}