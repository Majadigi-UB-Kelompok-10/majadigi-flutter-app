import 'package:flutter/material.dart' show debugPrint;

import '../../domain/entities/pengumuman/jd_pengumuman_entity.dart';
import '../../domain/entities/search/jd_search_result_entity.dart';
import '../../domain/entities/dokumen/jd_dokumen_entity.dart';
import '../../domain/entities/dokumen_detail/jd_dokumen_detail_entity.dart';
import '../../domain/entities/filter/jd_jenis_filter_entity.dart';
import '../../domain/entities/pagination/jd_pagination_entity.dart';
import '../../domain/repositories/jd_repository.dart';
import '../datasources/jd_local_datasource.dart';
import '../datasources/jd_remote_datasource.dart';
import '../models/dto/pengumuman/pengumuman_dto.dart';
import '../models/dto/search/search_result_dto.dart';
import '../models/dto/dokumen/dokumen_dto.dart';
import '../models/dto/dokumen_detail/dokumen_detail_dto.dart';
import '../models/dto/filter/jenis_filter_dto.dart';
import '../models/dto/pagination/pagination_dto.dart';
import '../models/isar/pengumuman/jd_pengumuman_registry.dart';
import '../models/isar/filter/jd_jenis_filter_registry.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// ---------------------------------------------------------------------------

extension PengumumanDtoToIsar on PengumumanDto {
  IsarJdPengumumanRegistry toIsar() {
    return IsarJdPengumumanRegistry()
      ..id = id
      ..judul = judul
      ..isi = isi
      ..tanggal = tanggal;
  }
}

extension JenisFilterDtoToIsar on JenisFilterDto {
  IsarJdJenisFilterRegistry toIsar() {
    return IsarJdJenisFilterRegistry()
      ..value = value
      ..label = label;
  }
}

// ---------------------------------------------------------------------------
// DTO → Entity Mapping (for non-cached, remote-only data)
// ---------------------------------------------------------------------------

extension SearchResultDtoToEntity on SearchResultDto {
  JdSearchResultEntity toEntity() {
    return JdSearchResultEntity(
      id: id,
      jenis: jenis,
      judul: judul,
      ringkasan: ringkasan,
      tanggal: tanggal,
      status: status,
      jumlahView: jumlahView,
    );
  }
}

extension DokumenDtoToEntity on DokumenDto {
  JdDokumenEntity toEntity() {
    return JdDokumenEntity(
      id: id,
      jenis: jenis,
      judul: judul,
      tanggal: tanggal,
      status: status,
      pdfUrl: pdfUrl,
    );
  }
}

extension DokumenDetailDtoToEntity on DokumenDetailDto {
  JdDokumenDetailEntity toEntity() {
    return JdDokumenDetailEntity(
      id: id,
      jenis: jenis,
      nomor: nomor,
      tahun: tahun,
      judul: judul,
      ringkasan: ringkasan,
      tanggalPenetapan: tanggalPenetapan,
      status: status,
      pdfUrl: pdfUrl,
      pdfSizeKb: pdfSizeKb,
      urusanPemerintahan: urusanPemerintahan,
      jumlahView: jumlahView,
      subjek: subjek
          ?.map((s) => JdSubjekEntity(id: s.id, nama: s.nama))
          .toList(),
    );
  }
}

extension PaginationDtoToEntity on PaginationDto {
  JdPaginationEntity toEntity() {
    return JdPaginationEntity(
      page: page,
      limit: limit,
      total: total,
    );
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class JdRepositoryImpl implements JdRepository {
  final JdLocalDatasource localDatasource;
  final JdRemoteDatasource remoteDatasource;

  JdRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  // -- Pengumuman (SWR) --

  @override
  Future<List<JdPengumumanEntity>> getPengumuman() async {
    await syncPengumuman();
    final cached = await localDatasource.getCachedPengumuman();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Stream<List<JdPengumumanEntity>> watchPengumuman() {
    syncPengumuman();
    return localDatasource.watchCachedPengumuman().map((items) {
      return items.map((r) => r.toEntity()).toList();
    });
  }

  @override
  Future<void> syncPengumuman() async {
    try {
      final dtos = await remoteDatasource.fetchPengumuman();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cachePengumuman(registries);
    } catch (e) { /* Silently fail — cached data still available */ }
  }

  // -- Jenis Filters (SWR) --

  @override
  Future<List<JdJenisFilterEntity>> getJenisFilters() async {
    await syncJenisFilters();
    final cached = await localDatasource.getCachedJenisFilters();
    return cached.map((r) => r.toEntity()).toList();
  }

  @override
  Stream<List<JdJenisFilterEntity>> watchJenisFilters() {
    syncJenisFilters();
    return localDatasource.watchCachedJenisFilters().map((items) {
      return items.map((r) => r.toEntity()).toList();
    });
  }

  @override
  Future<void> syncJenisFilters() async {
    try {
      final dtos = await remoteDatasource.fetchJenisFilters();
      if (dtos == null) return;
      final registries = dtos.map((d) => d.toIsar()).toList();
      await localDatasource.cacheJenisFilters(registries);
    } catch (e) { /* Silently fail — cached data still available */ }
  }

  // -- Tahun Filters (remote only) --

  @override
  Future<List<int>> getTahunFilters() async {
    final years = await remoteDatasource.fetchTahunFilters();

    debugPrint("getTahunFilters(): ${years.toString()}");

    return years ?? [];
  }

  // -- Tahun by Jenis (remote only) --

  @override
  Future<List<int>> getTahunByJenis(String jenis) async {
    final years = await remoteDatasource.fetchTahunByJenis(jenis);
    return years ?? [];
  }

  // -- Search (remote only) --

  @override
  Future<({List<JdSearchResultEntity> results, JdPaginationEntity? pagination})>
      searchDokumen({
    String? keyword,
    String? nomor,
    String? tahun,
    String? jenis,
    String? sort,
    int? page,
    int? limit,
  }) async {
    final response = await remoteDatasource.fetchSearch(
      keyword: keyword,
      nomor: nomor,
      tahun: tahun,
      jenis: jenis,
      sort: sort,
      page: page,
      limit: limit,
    );
    if (response == null) return (results: <JdSearchResultEntity>[], pagination: null);

    return (
      results: response.results.map((d) => d.toEntity()).toList(),
      pagination: response.pagination?.toEntity(),
    );
  }

  // -- Dokumen by Jenis (remote only) --

  @override
  Future<({List<JdDokumenEntity> results, JdPaginationEntity? pagination})>
      getDokumenByJenis({
    required String jenis,
    String? keyword,
    String? tahun,
    int? page,
    int? limit,
  }) async {
    final response = await remoteDatasource.fetchDokumenByJenis(
      jenis: jenis,
      keyword: keyword,
      tahun: tahun,
      page: page,
      limit: limit,
    );
    if (response == null) return (results: <JdDokumenEntity>[], pagination: null);

    return (
      results: response.results.map((d) => d.toEntity()).toList(),
      pagination: response.pagination?.toEntity(),
    );
  }

  // -- Dokumen Detail (remote only) --

  @override
  Future<JdDokumenDetailEntity?> getDokumenDetail(int id) async {
    final dto = await remoteDatasource.fetchDokumenDetail(id);
    return dto?.toEntity();
  }
}
