import 'package:majadigi_mobile_rebuild/data/datasources/operational/operational_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/operational/operational_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/operational/operational_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/operational_repository.dart';

class OperationalRepositoryImpl implements OperationalRepository {
  final OperationalLocalDatasource localDatasource;
  final OperationalRemoteDatasource remoteDatasource;

  OperationalRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<OperationalEntity> getOperationalForService(String serviceId) {
    return localDatasource.getCachedOperationalForService(serviceId).then((operational) {
      return operational.first.toEntity();
    });
  }

  @override
  Future<void> syncOperationals() async {
    try {
      final operational = await remoteDatasource.fetchOperationalFromNetwork();

      final operationalIsar = operational.map((operational) => operational.toIsar()).toList();

      localDatasource.cacheOperational(operationalIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<OperationalEntity> watchOperationalForService(String serviceId) {
    return localDatasource.watchCachedOperationalForService(serviceId).map((operational) {
      return operational.first.toEntity();
    });
  }
}