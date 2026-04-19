import 'package:majadigi_mobile_rebuild/domain/entities/endpoint/endpoint_entity.dart';

/// Represent Contract for Endpoints
abstract class EndpointRepository {
  Future<EndpointEntity> getEndpointForIntegration(String integrationId);
}