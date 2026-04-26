import 'package:majadigi_mobile_rebuild/domain/entities/endpoint/endpoint_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/endpoint_repository.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/endpoint/endpoint_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/endpoint/endpoint_remote_datasource.dart';

class EndpointRepositoryImpl implements EndpointRepository {
  final EndpointLocalDatasource localDatasource;
  final EndpointRemoteDatasource remoteDatasource;

  EndpointRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<EndpointEntity> getEndpointForIntegration(String fkEndpointId) {
    return localDatasource.getCachedEndpointForIntegration(fkEndpointId).then((endpoint) {
      return endpoint.first.toEntity();
    });
  }

  @override
  Future<void> syncEndpoints() async {
    try {
      final endpoints = await remoteDatasource.fetchEndpointFromNetwork();

      if (endpoints == null) return;

      final endpointIsar = endpoints.map((endpoint) => endpoint.toIsar()).toList();

      localDatasource.cacheEndpoint(endpointIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<EndpointEntity> watchEndpointForIntegration(String fkEndpointId) {
    throw UnimplementedError();
  }
}