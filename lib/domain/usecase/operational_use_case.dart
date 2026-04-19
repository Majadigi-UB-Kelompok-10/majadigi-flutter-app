import 'package:majadigi_mobile_rebuild/domain/repositories/operational_repository.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/operational/operational_entity.dart';

/// Watch Operational based on Service Id
/// @return Stream<OperationalEntity>
class WatchOperationalForServiceUseCase {
  final OperationalRepository repository;

  WatchOperationalForServiceUseCase(this.repository);

  Stream<OperationalEntity> execute(String serviceId) {
    return repository.watchOperationalForService(serviceId);
  }
}

/// Sync Operational from Remote Datasource
/// @return void
class SyncOperationalsUseCase {
  final OperationalRepository repository;

  SyncOperationalsUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncOperationals();
  }
}

/// Get Operational based on Service Id
/// @return OperationalEntity
class GetOperationalForServiceUseCase {
  final OperationalRepository repository;

  GetOperationalForServiceUseCase(this.repository);

  Future<OperationalEntity> execute(String serviceId) async {
    return await repository.getOperationalForService(serviceId);
  }
}