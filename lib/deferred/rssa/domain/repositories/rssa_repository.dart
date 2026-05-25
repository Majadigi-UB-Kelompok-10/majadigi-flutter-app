import '../entities/summary/rssa_summary_entity.dart';
import '../entities/kelas/rssa_kelas_entity.dart';
import '../entities/ruangan/rssa_ruangan_entity.dart';

abstract class RssaRepository {
  // SWR Pattern: Get cached data immediately, trigger sync in background
  Stream<RssaSummaryEntity?> getSummary();
  Stream<List<RssaKelasEntity>> getKelas();
  
  // Remote-filtered fetch
  Stream<List<RssaRuanganEntity>> getRuangan({String search = '', String kelas = ''});
  
  // Local Isar-only filtering (no remote call)
  Stream<List<RssaRuanganEntity>> getRuanganLocal({String search = '', String kelas = ''});

  // Background sync methods
  Future<void> syncSummary();
  Future<void> syncKelas();
  Future<void> syncRuangan({String search = '', String kelas = ''});
}
