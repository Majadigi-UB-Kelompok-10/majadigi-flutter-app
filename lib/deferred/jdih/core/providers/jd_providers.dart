import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../data/datasources/jd_local_datasource.dart';
import '../../data/datasources/jd_remote_datasource.dart';
import '../../data/repositories/jd_repository_impl.dart';
import '../../domain/repositories/jd_repository.dart';
import '../../domain/usecase/jd_use_cases.dart';
import '../../domain/entities/pengumuman/jd_pengumuman_entity.dart';
import '../../domain/entities/search/jd_search_result_entity.dart';
import '../../domain/entities/dokumen/jd_dokumen_entity.dart';
import '../../domain/entities/dokumen_detail/jd_dokumen_detail_entity.dart';
import '../../domain/entities/filter/jd_jenis_filter_entity.dart';
import '../../domain/entities/pagination/jd_pagination_entity.dart';

part 'jd_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
JdLocalDatasource _jdLocalDatasource(Ref ref) {
  final isar = ref.watch(jdIsarProvider).requireValue;
  return JdLocalDatasourceImpl(isar);
}

@riverpod
JdRemoteDatasource _jdRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return JdRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
JdRepository _jdRepository(Ref ref) {
  return JdRepositoryImpl(
    localDatasource: ref.watch(_jdLocalDatasourceProvider),
    remoteDatasource: ref.watch(_jdRemoteDatasourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
GetPengumumanUseCase _getPengumumanUseCase(Ref ref) {
  return GetPengumumanUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
WatchPengumumanUseCase _watchPengumumanUseCase(Ref ref) {
  return WatchPengumumanUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
GetJenisFiltersUseCase _getJenisFiltersUseCase(Ref ref) {
  return GetJenisFiltersUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
WatchJenisFiltersUseCase _watchJenisFiltersUseCase(Ref ref) {
  return WatchJenisFiltersUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
GetTahunFiltersUseCase _getTahunFiltersUseCase(Ref ref) {
  return GetTahunFiltersUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
GetTahunByJenisUseCase _getTahunByJenisUseCase(Ref ref) {
  return GetTahunByJenisUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
SearchDokumenUseCase _searchDokumenUseCase(Ref ref) {
  return SearchDokumenUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
GetDokumenByJenisUseCase _getDokumenByJenisUseCase(Ref ref) {
  return GetDokumenByJenisUseCase(ref.watch(_jdRepositoryProvider));
}

@riverpod
GetDokumenDetailUseCase _getDokumenDetailUseCase(Ref ref) {
  return GetDokumenDetailUseCase(ref.watch(_jdRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

/// Get all pengumuman (announcements)
@riverpod
Future<List<JdPengumumanEntity>> jdPengumuman(Ref ref) {
  final useCase = ref.watch(_getPengumumanUseCaseProvider);
  return useCase.execute();
}

/// Get all jenis filter options
@riverpod
Future<List<JdJenisFilterEntity>> jdJenisFilters(Ref ref) {
  final useCase = ref.watch(_getJenisFiltersUseCaseProvider);
  return useCase.execute();
}

/// Get all tahun filter options
@riverpod
Future<List<int>> jdTahunFilters(Ref ref) {
  final useCase = ref.watch(_getTahunFiltersUseCaseProvider);
  return useCase.execute();
}

/// Get tahun filter options for a specific jenis
@riverpod
Future<List<int>> jdTahunByJenis(Ref ref, String jenis) {
  final useCase = ref.watch(_getTahunByJenisUseCaseProvider);
  return useCase.execute(jenis);
}

/// Search dokumen with optional filters and pagination
@riverpod
Future<({List<JdSearchResultEntity> results, JdPaginationEntity? pagination})>
    jdSearchDokumen(
  Ref ref, {
  String? keyword,
  String? nomor,
  String? tahun,
  String? jenis,
  String? sort,
  int? page,
  int? limit,
}) {
  final useCase = ref.watch(_searchDokumenUseCaseProvider);
  return useCase.execute(
    keyword: keyword,
    nomor: nomor,
    tahun: tahun,
    jenis: jenis,
    sort: sort,
    page: page,
    limit: limit,
  );
}

/// Get dokumen list by jenis with optional filters and pagination
@riverpod
Future<({List<JdDokumenEntity> results, JdPaginationEntity? pagination})>
    jdDokumenByJenis(
  Ref ref, {
  required String jenis,
  String? keyword,
  String? tahun,
  int? page,
  int? limit,
}) {
  final useCase = ref.watch(_getDokumenByJenisUseCaseProvider);
  return useCase.execute(
    jenis: jenis,
    keyword: keyword,
    tahun: tahun,
    page: page,
    limit: limit,
  );
}

/// Get detail of a specific dokumen by ID
@riverpod
Future<JdDokumenDetailEntity?> jdDokumenDetail(Ref ref, int id) {
  final useCase = ref.watch(_getDokumenDetailUseCaseProvider);
  return useCase.execute(id);
}
