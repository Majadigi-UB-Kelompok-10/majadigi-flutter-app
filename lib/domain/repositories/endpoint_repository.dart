import 'package:majadigi_mobile_rebuild/domain/entities/endpoint/endpoint_entity.dart';

/// Represent Contract for Endpoints
abstract class EndpointRepository {
  // SWR Specific Implementation
  Stream<EndpointEntity> watchEndpointForIntegration(String fkEndpointId);
  Future<void> syncEndpoints();

  // General Use Case
  Future<EndpointEntity> getEndpointForIntegration(String fkEndpointId);
}