import '../entities/pengumuman/jd_pengumuman_entity.dart';
import '../entities/search/jd_search_result_entity.dart';
import '../entities/dokumen/jd_dokumen_entity.dart';
import '../entities/dokumen_detail/jd_dokumen_detail_entity.dart';
import '../entities/filter/jd_jenis_filter_entity.dart';
import '../entities/pagination/jd_pagination_entity.dart';
import '../repositories/jd_repository.dart';

// ---------------------------------------------------------------------------
// Pengumuman Use Cases
// ---------------------------------------------------------------------------

class GetPengumumanUseCase {
  final JdRepository repository;
  GetPengumumanUseCase(this.repository);

  Future<List<JdPengumumanEntity>> execute() {
    return repository.getPengumuman();
  }
}

class WatchPengumumanUseCase {
  final JdRepository repository;
  WatchPengumumanUseCase(this.repository);

  Stream<List<JdPengumumanEntity>> execute() {
    return repository.watchPengumuman();
  }
}

// ---------------------------------------------------------------------------
// Filter Use Cases
// ---------------------------------------------------------------------------

class GetJenisFiltersUseCase {
  final JdRepository repository;
  GetJenisFiltersUseCase(this.repository);

  Future<List<JdJenisFilterEntity>> execute() {
    return repository.getJenisFilters();
  }
}

class WatchJenisFiltersUseCase {
  final JdRepository repository;
  WatchJenisFiltersUseCase(this.repository);

  Stream<List<JdJenisFilterEntity>> execute() {
    return repository.watchJenisFilters();
  }
}

class GetTahunFiltersUseCase {
  final JdRepository repository;
  GetTahunFiltersUseCase(this.repository);

  Future<List<int>> execute() {
    return repository.getTahunFilters();
  }
}

class GetTahunByJenisUseCase {
  final JdRepository repository;
  GetTahunByJenisUseCase(this.repository);

  Future<List<int>> execute(String jenis) {
    return repository.getTahunByJenis(jenis);
  }
}

// ---------------------------------------------------------------------------
// Search Use Case
// ---------------------------------------------------------------------------

class SearchDokumenUseCase {
  final JdRepository repository;
  SearchDokumenUseCase(this.repository);

  Future<({List<JdSearchResultEntity> results, JdPaginationEntity? pagination})>
      execute({
    String? keyword,
    String? nomor,
    String? tahun,
    String? jenis,
    String? sort,
    int? page,
    int? limit,
  }) {
    return repository.searchDokumen(
      keyword: keyword,
      nomor: nomor,
      tahun: tahun,
      jenis: jenis,
      sort: sort,
      page: page,
      limit: limit,
    );
  }
}

// ---------------------------------------------------------------------------
// Dokumen by Jenis Use Case
// ---------------------------------------------------------------------------

class GetDokumenByJenisUseCase {
  final JdRepository repository;
  GetDokumenByJenisUseCase(this.repository);

  Future<({List<JdDokumenEntity> results, JdPaginationEntity? pagination})>
      execute({
    required String jenis,
    String? keyword,
    String? tahun,
    int? page,
    int? limit,
  }) {
    return repository.getDokumenByJenis(
      jenis: jenis,
      keyword: keyword,
      tahun: tahun,
      page: page,
      limit: limit,
    );
  }
}

// ---------------------------------------------------------------------------
// Dokumen Detail Use Case
// ---------------------------------------------------------------------------

class GetDokumenDetailUseCase {
  final JdRepository repository;
  GetDokumenDetailUseCase(this.repository);

  Future<JdDokumenDetailEntity?> execute(int id) {
    return repository.getDokumenDetail(id);
  }
}
