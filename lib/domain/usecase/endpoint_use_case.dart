import 'package:majadigi_mobile_rebuild/domain/entities/endpoint/endpoint_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/endpoint_repository.dart';

/// Get endpoints based on integrationId
/// @return EndpointEntity
class GetEndpointForIntegrationUseCase {
  final EndpointRepository repository;
  GetEndpointForIntegrationUseCase(this.repository);

  Future<EndpointEntity> execute(String integrationId) async {
    return await repository.getEndpointForIntegration(integrationId);
  }
}