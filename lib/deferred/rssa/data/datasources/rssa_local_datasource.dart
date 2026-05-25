import 'package:isar_community/isar.dart';
import '../models/isar/summary/rssa_summary_registry.dart';
import '../models/isar/kelas/rssa_kelas_registry.dart';
import '../models/isar/ruangan/rssa_ruangan_registry.dart';

abstract class RssaLocalDatasource {
  Stream<IsarRssaSummaryRegistry?> watchSummary();
  Stream<List<IsarRssaKelasRegistry>> watchKelas();
  
  // Watch all cached ruangan (used for local-only filtering)
  Stream<List<IsarRssaRuanganRegistry>> watchAllRuangan();
  
  // Watch specific query (used for remote-synced filtering)
  Stream<List<IsarRssaRuanganRegistry>> watchRuangan({String search = '', String kelas = ''});

  Future<void> saveSummary(IsarRssaSummaryRegistry summary);
  Future<void> saveKelas(List<IsarRssaKelasRegistry> kelasList);
  Future<void> saveRuangan(List<IsarRssaRuanganRegistry> ruanganList, {String search = '', String kelas = ''});
}

class RssaLocalDatasourceImpl implements RssaLocalDatasource {
  final Isar isar;
  RssaLocalDatasourceImpl(this.isar);

  @override
  Stream<IsarRssaSummaryRegistry?> watchSummary() {
    return isar.isarRssaSummaryRegistrys.where().watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  @override
  Stream<List<IsarRssaKelasRegistry>> watchKelas() {
    return isar.isarRssaKelasRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<IsarRssaRuanganRegistry>> watchAllRuangan() {
    // Return unique ruangan by ruanganId to avoid duplicates from different query caches
    return isar.isarRssaRuanganRegistrys.where().watch(fireImmediately: true)
      .map((list) {
        final uniqueMap = <int, IsarRssaRuanganRegistry>{};
        for (final item in list) {
          if (!uniqueMap.containsKey(item.ruanganId)) {
            uniqueMap[item.ruanganId] = item;
          }
        }
        return uniqueMap.values.toList();
      });
  }

  @override
  Stream<List<IsarRssaRuanganRegistry>> watchRuangan({String search = '', String kelas = ''}) {
    return isar.isarRssaRuanganRegistrys
        .filter()
        .querySearchEqualTo(search)
        .and()
        .queryKelasEqualTo(kelas)
        .watch(fireImmediately: true);
  }

  @override
  Future<void> saveSummary(IsarRssaSummaryRegistry summary) async {
    await isar.writeTxn(() async {
      await isar.isarRssaSummaryRegistrys.clear();
      await isar.isarRssaSummaryRegistrys.put(summary);
    });
  }

  @override
  Future<void> saveKelas(List<IsarRssaKelasRegistry> kelasList) async {
    await isar.writeTxn(() async {
      await isar.isarRssaKelasRegistrys.clear();
      await isar.isarRssaKelasRegistrys.putAll(kelasList);
    });
  }

  @override
  Future<void> saveRuangan(List<IsarRssaRuanganRegistry> ruanganList, {String search = '', String kelas = ''}) async {
    await isar.writeTxn(() async {
      // Clear only the cache for this specific query combination
      await isar.isarRssaRuanganRegistrys
          .filter()
          .querySearchEqualTo(search)
          .and()
          .queryKelasEqualTo(kelas)
          .deleteAll();
          
      await isar.isarRssaRuanganRegistrys.putAll(ruanganList);
    });
  }
}
