import '../entities/pengumuman/jd_pengumuman_entity.dart';
import '../entities/search/jd_search_result_entity.dart';
import '../entities/dokumen/jd_dokumen_entity.dart';
import '../entities/dokumen_detail/jd_dokumen_detail_entity.dart';
import '../entities/filter/jd_jenis_filter_entity.dart';
import '../entities/pagination/jd_pagination_entity.dart';

/// Contract for all JDIH data operations.
/// Implementation lives in data/repositories/jd_repository_impl.dart
abstract class JdRepository {
  // -- Pengumuman (SWR cached) --
  Future<List<JdPengumumanEntity>> getPengumuman();
  Stream<List<JdPengumumanEntity>> watchPengumuman();
  Future<void> syncPengumuman();

  // -- Jenis Filter (SWR cached) --
  Future<List<JdJenisFilterEntity>> getJenisFilters();
  Stream<List<JdJenisFilterEntity>> watchJenisFilters();
  Future<void> syncJenisFilters();

  // -- Tahun Filter (remote only, returns List<int>) --
  Future<List<int>> getTahunFilters();

  // -- Tahun by Jenis (remote only, returns List<int>) --
  Future<List<int>> getTahunByJenis(String jenis);

  // -- Search (remote only, parameterized + paginated) --
  Future<({List<JdSearchResultEntity> results, JdPaginationEntity? pagination})>
      searchDokumen({
    String? keyword,
    String? nomor,
    String? tahun,
    String? jenis,
    String? sort,
    int? page,
    int? limit,
  });

  // -- Dokumen by Jenis (remote only, parameterized + paginated) --
  Future<({List<JdDokumenEntity> results, JdPaginationEntity? pagination})>
      getDokumenByJenis({
    required String jenis,
    String? keyword,
    String? tahun,
    int? page,
    int? limit,
  });

  // -- Dokumen Detail (remote only) --
  Future<JdDokumenDetailEntity?> getDokumenDetail(int id);
}
