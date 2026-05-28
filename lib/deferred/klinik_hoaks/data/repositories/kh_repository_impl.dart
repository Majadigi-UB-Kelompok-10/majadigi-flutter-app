import 'dart:io';
import '../../domain/entities/stat/kh_stat_entity.dart';
import '../../domain/entities/news/kh_news_entity.dart';
import '../../domain/entities/news/kh_news_detail_entity.dart';
import '../../domain/entities/report/kh_report_response_entity.dart';
import '../../domain/entities/report/kh_track_report_entity.dart';
import '../../domain/repositories/kh_repository.dart';
import '../datasources/kh_local_datasource.dart';
import '../datasources/kh_remote_datasource.dart';
import '../models/dto/klinik_hoaks/klinik_hoaks_dto.dart';
import '../models/isar/stat/kh_stat_registry.dart';
import '../models/isar/news/kh_news_registry.dart';
import '../models/isar/news/kh_news_detail_registry.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// ---------------------------------------------------------------------------

extension KhStatDtoToIsar on KhStatDto {
  IsarKhStatRegistry toIsar() {
    return IsarKhStatRegistry()
      ..categoryId = categoryId ?? ''
      ..categoryName = categoryName ?? ''
      ..categorySlug = categorySlug ?? ''
      ..iconUrl = iconUrl
      ..totalNews = totalNews ?? 0;
  }
}

extension KhNewsDtoToIsar on KhNewsDto {
  IsarKhNewsRegistry toIsar() {
    return IsarKhNewsRegistry()
      ..newsId = id ?? ''
      ..title = title ?? ''
      ..slug = slug ?? ''
      ..imageUrl = imageUrl
      ..categoryName = categoryName
      ..categorySlug = categorySlug
      ..publishedAt = publishedAt;
  }
}

extension KhNewsDetailDtoToIsar on KhNewsDetailDto {
  IsarKhNewsDetailRegistry toIsar() {
    return IsarKhNewsDetailRegistry()
      ..newsId = id ?? ''
      ..title = title
      ..slug = slug ?? ''
      ..description = description
      ..referenceLink = referenceLink
      ..imageUrl = imageUrl
      ..categoryName = categoryName
      ..categorySlug = categorySlug
      ..publishedAt = publishedAt;
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class KhRepositoryImpl implements KhRepository {
  final KhLocalDatasource local;
  final KhRemoteDatasource remote;

  KhRepositoryImpl({required this.local, required this.remote});

  // -- Stats (SWR) --

  @override
  Stream<List<KhStatEntity>> getStats() {
    return local.watchStats().map(
      (list) => list.map((r) => r.toEntity()).toList(),
    );
  }

  @override
  Future<void> syncStats() async {
    try {
      final dtos = await remote.fetchStats();
      if (dtos == null || dtos.isEmpty) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await local.saveStats(registries);
    } catch (e) {
      // Silently fail — cached data still available
    }
  }

  // -- News (SWR) --

  @override
  Stream<List<KhNewsEntity>> getNews() {
    return local.watchNews().map(
      (list) => list.map((r) => r.toEntity()).toList(),
    );
  }

  @override
  Future<void> syncNews() async {
    try {
      final dtos = await remote.fetchNews();
      if (dtos == null || dtos.isEmpty) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await local.saveNews(registries);
    } catch (e) {
      // Silently fail — cached data still available
    }
  }

  // -- News Search (local Isar filter) --

  @override
  Stream<List<KhNewsEntity>> searchNews(String query) {
    return local.searchNews(query).map(
      (list) => list.map((r) => r.toEntity()).toList(),
    );
  }

  // -- News Detail (cached on-demand) --

  @override
  Future<KhNewsDetailEntity?> getNewsDetail(String slug) async {
    final cached = await local.getNewsDetailBySlug(slug);
    return cached?.toEntity();
  }

  @override
  Future<void> syncNewsDetail(String slug) async {
    try {
      final dto = await remote.fetchNewsDetail(slug);
      if (dto == null) return;

      final registry = dto.toIsar();
      await local.saveNewsDetail(registry);
    } catch (e) {
      // Silently fail — cached data still available
    }
  }

  // -- Report (direct remote) --

  @override
  Future<KhReportResponseEntity?> submitReport({
    required String nama,
    required String email,
    required String noHp,
    required String isiLaporan,
    String? linkBukti,
    File? gambarBukti,
  }) async {
    try {
      final dto = await remote.submitReport(
        nama: nama,
        email: email,
        noHp: noHp,
        isiLaporan: isiLaporan,
        linkBukti: linkBukti,
        gambarBukti: gambarBukti,
      );
      if (dto == null) return null;

      return KhReportResponseEntity(
        ticketNumber: dto.ticketNumber,
        createdAt: dto.createdAt,
      );
    } catch (e) {
      return null;
    }
  }

  // -- Track Report (direct remote) --

  @override
  Future<KhTrackReportEntity?> trackReport(String ticketNumber) async {
    try {
      final dto = await remote.trackReport(ticketNumber);
      if (dto == null) return null;

      return KhTrackReportEntity(
        reportId: dto.reportId,
        ticketNumber: dto.ticketNumber,
        reporterName: dto.reporterName,
        reportStatus: dto.reportStatus,
        reportedAt: dto.reportedAt,
      );
    } catch (e) {
      return null;
    }
  }
}
