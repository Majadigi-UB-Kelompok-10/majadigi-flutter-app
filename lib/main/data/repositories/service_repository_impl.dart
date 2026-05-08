import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/service/service_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDatasource localDatasource;
  final ServiceRemoteDatasource remoteDatasource;

  ServiceRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  // SWR Implementation from Stream
  @override
  Stream<List<ServiceEntity>> watchAllServices() {
    return localDatasource.watchCachedServices().map((services) {
      return services.map((service) => service.toEntity()).toList();
    });
  }

  // Sync database with remote datasource
  @override
  Future<void> syncServices() async {
    try {
      final normalizedPayload = await remoteDatasource.fetchNormalizedServicesFromNetwork();

      if (normalizedPayload == null) return;

      await localDatasource.processAndCacheServices(normalizedPayload);
    } catch (e) { /* None */ }
  }

  @override
  Future<List<ServiceEntity>> getAllServicesInCategory(String categoryId) async {
    return await localDatasource.getCachedServicesInCategory(categoryId).then((services) {
      return services.map((service) => service.toEntity()).toList();
    });
  }
}