import 'package:majadigi_mobile_rebuild/domain/entities/operational/operational_entity.dart';

/// Represent Contract for Operationals
abstract class OperationalRepository {
  // SWR Specific Implementation
  Stream<OperationalEntity> watchOperationalForService(String serviceId);
  Future<void> syncOperationals();

  // General Use Case
  Future<OperationalEntity> getOperationalForService(String serviceId);
}