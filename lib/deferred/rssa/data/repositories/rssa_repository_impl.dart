import '../../domain/entities/summary/rssa_summary_entity.dart';
import '../../domain/entities/kelas/rssa_kelas_entity.dart';
import '../../domain/entities/ruangan/rssa_ruangan_entity.dart';
import '../../domain/repositories/rssa_repository.dart';
import '../datasources/rssa_local_datasource.dart';
import '../datasources/rssa_remote_datasource.dart';
import '../models/dto/summary/summary_dto.dart';
import '../models/dto/kelas/kelas_dto.dart';
import '../models/dto/ruangan/ruangan_dto.dart';
import '../models/isar/summary/rssa_summary_registry.dart';
import '../models/isar/kelas/rssa_kelas_registry.dart';
import '../models/isar/ruangan/rssa_ruangan_registry.dart';

extension SummaryDtoToIsar on SummaryDto {
  IsarRssaSummaryRegistry toIsar() {
    return IsarRssaSummaryRegistry()
      ..totalKapasitas = totalKapasitas ?? 0
      ..totalTersedia = totalTersedia ?? 0;
  }
}

extension KelasDtoToIsar on KelasDto {
  IsarRssaKelasRegistry toIsar() {
    return IsarRssaKelasRegistry()
      ..kelasId = id ?? 0
      ..nama = nama ?? ''
      ..slug = slug ?? '';
  }
}

extension RuanganDtoToIsar on RuanganDto {
  IsarRssaRuanganRegistry toIsar({required String qSearch, required String qKelas}) {
    return IsarRssaRuanganRegistry()
      ..compositeId = '${id}_${qSearch}_$qKelas'
      ..ruanganId = id
      ..nama = nama ?? ''
      ..slug = slug ?? ''
      ..kelasNama = kelasNama ?? ''
      ..kelasSlug = kelasSlug ?? ''
      ..kapasitas = kapasitas ?? 0
      ..terisi = terisi ?? 0
      ..tersedia = tersedia ?? 0
      ..querySearch = qSearch
      ..queryKelas = qKelas;
  }
}

class RssaRepositoryImpl implements RssaRepository {
  final RssaLocalDatasource local;
  final RssaRemoteDatasource remote;

  RssaRepositoryImpl({required this.local, required this.remote});

  @override
  Stream<RssaSummaryEntity?> getSummary() {
    return local.watchSummary().map((e) => e?.toEntity());
  }

  @override
  Stream<List<RssaKelasEntity>> getKelas() {
    return local.watchKelas().map((list) => list.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<List<RssaRuanganEntity>> getRuangan({String search = '', String kelas = ''}) {
    return local.watchRuangan(search: search, kelas: kelas)
        .map((list) => list.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<List<RssaRuanganEntity>> getRuanganLocal({String search = '', String kelas = ''}) {
    // This watches all cached ruangan (unique by ruanganId) and filters them locally
    // Used when we want instant offline filtering without waiting for an API call
    return local.watchAllRuangan().map((list) {
      return list.where((item) {
        final matchesSearch = search.isEmpty || item.nama.toLowerCase().contains(search.toLowerCase());
        final matchesKelas = kelas.isEmpty || item.kelasSlug == kelas;
        return matchesSearch && matchesKelas;
      }).map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<void> syncSummary() async {
    try {
      final remoteData = await remote.fetchSummary();

      if (remoteData == null) {
        return;
      }

      final isarData = remoteData.toIsar();

      await local.saveSummary(isarData);
    } catch (e) {
      // Handle error silently, use cache
    }
  }

  @override
  Future<void> syncKelas() async {
    try {
      final remoteData = await remote.fetchKelas();

      if (remoteData == null || remoteData.isEmpty) {
        return;
      }

      final isarData = remoteData.map((dto) => dto.toIsar()).toList();

      await local.saveKelas(isarData);
    } catch (e) {
      // Handle error silently, use cache
    }
  }

  @override
  Future<void> syncRuangan({String search = '', String kelas = ''}) async {
    try {
      final remoteData = await remote.fetchRuangan(search: search, kelas: kelas);

      if (remoteData == null || remoteData.isEmpty) {
        // If empty, we still want to save empty to clear the cache for this query
        await local.saveRuangan([], search: search, kelas: kelas);
        return;
      }

      final isarData = remoteData.map((dto) => dto.toIsar(qSearch: search, qKelas: kelas)).toList();

      await local.saveRuangan(isarData, search: search, kelas: kelas);
    } catch (e) {
      // Handle error silently, use cache
    }
  }
}
