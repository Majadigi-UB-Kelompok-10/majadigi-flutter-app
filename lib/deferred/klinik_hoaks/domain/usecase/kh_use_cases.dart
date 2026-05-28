import 'dart:io';
import '../entities/stat/kh_stat_entity.dart';
import '../entities/news/kh_news_entity.dart';
import '../entities/news/kh_news_detail_entity.dart';
import '../entities/report/kh_report_response_entity.dart';
import '../entities/report/kh_track_report_entity.dart';
import '../repositories/kh_repository.dart';

// ---------------------------------------------------------------------------
// Read Use Cases (SWR — stream from cache, sync in background)
// ---------------------------------------------------------------------------

class GetKhStatsUseCase {
  final KhRepository repository;
  GetKhStatsUseCase(this.repository);

  Stream<List<KhStatEntity>> call() {
    repository.syncStats();
    return repository.getStats();
  }
}

class GetKhNewsUseCase {
  final KhRepository repository;
  GetKhNewsUseCase(this.repository);

  Stream<List<KhNewsEntity>> call() {
    repository.syncNews();
    return repository.getNews();
  }
}

// ---------------------------------------------------------------------------
// Search Use Case (local Isar filter)
// ---------------------------------------------------------------------------

class SearchKhNewsUseCase {
  final KhRepository repository;
  SearchKhNewsUseCase(this.repository);

  Stream<List<KhNewsEntity>> call(String query) {
    return repository.searchNews(query);
  }
}

// ---------------------------------------------------------------------------
// On-demand cached Use Case
// ---------------------------------------------------------------------------

class GetKhNewsDetailUseCase {
  final KhRepository repository;
  GetKhNewsDetailUseCase(this.repository);

  Future<KhNewsDetailEntity?> call(String slug) async {
    // Try cache first
    final cached = await repository.getNewsDetail(slug);
    if (cached != null) {
      // Fire-and-forget sync to refresh cache in background
      repository.syncNewsDetail(slug);
      return cached;
    }

    // If not cached, fetch from remote and cache it
    await repository.syncNewsDetail(slug);
    return await repository.getNewsDetail(slug);
  }
}

// ---------------------------------------------------------------------------
// Direct Remote Use Cases (no caching)
// ---------------------------------------------------------------------------

class SubmitKhReportUseCase {
  final KhRepository repository;
  SubmitKhReportUseCase(this.repository);

  Future<KhReportResponseEntity?> call({
    required String nama,
    required String email,
    required String noHp,
    required String isiLaporan,
    String? linkBukti,
    File? gambarBukti,
  }) async {
    return await repository.submitReport(
      nama: nama,
      email: email,
      noHp: noHp,
      isiLaporan: isiLaporan,
      linkBukti: linkBukti,
      gambarBukti: gambarBukti,
    );
  }
}

class TrackKhReportUseCase {
  final KhRepository repository;
  TrackKhReportUseCase(this.repository);

  Future<KhTrackReportEntity?> call(String ticketNumber) async {
    return await repository.trackReport(ticketNumber);
  }
}
