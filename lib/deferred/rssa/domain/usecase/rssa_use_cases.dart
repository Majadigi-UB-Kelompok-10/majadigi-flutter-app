import '../entities/summary/rssa_summary_entity.dart';
import '../entities/kelas/rssa_kelas_entity.dart';
import '../entities/ruangan/rssa_ruangan_entity.dart';
import '../repositories/rssa_repository.dart';

class GetRssaSummaryUseCase {
  final RssaRepository repository;
  GetRssaSummaryUseCase(this.repository);

  Stream<RssaSummaryEntity?> call() {
    repository.syncSummary();
    return repository.getSummary();
  }
}

class GetRssaKelasUseCase {
  final RssaRepository repository;
  GetRssaKelasUseCase(this.repository);

  Stream<List<RssaKelasEntity>> call() {
    repository.syncKelas();
    return repository.getKelas();
  }
}

class GetRssaRuanganUseCase {
  final RssaRepository repository;
  GetRssaRuanganUseCase(this.repository);

  Stream<List<RssaRuanganEntity>> call({String search = '', String kelas = ''}) {
    repository.syncRuangan(search: search, kelas: kelas);
    return repository.getRuangan(search: search, kelas: kelas);
  }
}

class GetRssaRuanganLocalUseCase {
  final RssaRepository repository;
  GetRssaRuanganLocalUseCase(this.repository);

  Stream<List<RssaRuanganEntity>> call({String search = '', String kelas = ''}) {
    return repository.getRuanganLocal(search: search, kelas: kelas);
  }
}
