import '../entities/bansos/bansos_entity.dart';
import '../repositories/bansos_repository.dart';

class GetBansosUseCase {
  final BansosRepository repository;

  GetBansosUseCase(this.repository);

  Future<BansosEntity?> execute(String nik) {
    return repository.getBansosByNik(nik);
  }
}

class SyncBansosUseCase {
  final BansosRepository repository;

  SyncBansosUseCase(this.repository);

  Future<void> execute(String nik) {
    return repository.syncBansosByNik(nik);
  }
}

class WatchBansosUseCase {
  final BansosRepository repository;

  WatchBansosUseCase(this.repository);

  Stream<List<BansosEntity>> execute(String nik) {
    return repository.watchBansosByNik(nik);
  }
}
