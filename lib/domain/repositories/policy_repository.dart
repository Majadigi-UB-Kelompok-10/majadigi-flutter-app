import 'package:majadigi_mobile_rebuild/domain/entities/policy/policy_entity.dart';

/// Represent Contract for Policies
abstract class PolicyRepository {
  // SWR Specific Implementation
  Stream<PolicyEntity> watchPolicyForService(String serviceId);
  Future<void> syncPolicies();

  // General Use Case
  Future<PolicyEntity> getPolicyForService(String serviceId);
}