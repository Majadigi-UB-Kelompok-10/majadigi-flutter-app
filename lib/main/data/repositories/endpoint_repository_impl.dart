import 'package:majadigi_mobile_rebuild/main/domain/entities/endpoint/endpoint_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/endpoint_repository.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/endpoint/endpoint_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/endpoint/endpoint_remote_datasource.dart';

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
  Future<EndpointEntity> getEndpointForIntegration(String fkEndpointId) async {
    final cachedEndpoint = await localDatasource.getCachedEndpointForIntegration(fkEndpointId);

    if (cachedEndpoint.isEmpty) {
      return EndpointEntity();
    }

    return cachedEndpoint.first.toEntity();
  }

  @override
  Future<void> syncEndpoints() async {
    try {
      final endpoints = await remoteDatasource.fetchEndpointFromNetwork();

      if (endpoints == null) return;

      final endpointIsar = endpoints.map((endpoint) => endpoint.toIsar()).toList();

      await localDatasource.cacheEndpoint(endpointIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<EndpointEntity?> watchEndpointForIntegration(String fkEndpointId) {
    return localDatasource.watchCachedEndpointForIntegration(fkEndpointId).map((endpoint) {
      if (endpoint.isNotEmpty) {
        return endpoint.first.toEntity();
      }

      return null;
    });
  }
}