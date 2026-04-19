import 'package:majadigi_mobile_rebuild/domain/entities/operational/operational_entity.dart';

/// Represent Contract for Operationals
abstract class OperationalRepository {
  Future<OperationalEntity> getOperationalForService(String serviceId);
}