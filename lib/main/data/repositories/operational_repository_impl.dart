import 'package:majadigi_mobile_rebuild/main/data/datasources/operational/operational_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/operational/operational_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/operational/operational_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/operational_repository.dart';

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
  Future<OperationalEntity?> getOperationalForService(String serviceId) async {
    final cachedOperational = await localDatasource.getCachedOperationalForService(serviceId);

    if (cachedOperational.isEmpty) {
        return null;
    }

    return cachedOperational.first.toEntity();
  }

  @override
  Future<void> syncOperationals() async {
    try {
      final operational = await remoteDatasource.fetchOperationalFromNetwork();

      if (operational == null) return;

      final operationalIsar = operational.map((operational) => operational.toIsar()).toList();

      await localDatasource.cacheOperational(operationalIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<OperationalEntity?> watchOperationalForService(String serviceId) {
    return localDatasource.watchCachedOperationalForService(serviceId).map((operational) {
      if (operational.isNotEmpty) {
        return operational.first.toEntity();
      }

      return null;
    });
  }
}