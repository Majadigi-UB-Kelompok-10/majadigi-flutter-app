import 'dart:io';
import '../entities/stat/kh_stat_entity.dart';
import '../entities/news/kh_news_entity.dart';
import '../entities/news/kh_news_detail_entity.dart';
import '../entities/report/kh_report_response_entity.dart';
import '../entities/report/kh_track_report_entity.dart';

abstract class KhRepository {
  // SWR cached — stats
  Stream<List<KhStatEntity>> getStats();
  Future<void> syncStats();

  // SWR cached — news
  Stream<List<KhNewsEntity>> getNews();
  Future<void> syncNews();

  // Cached on-demand — search (local Isar filter)
  Stream<List<KhNewsEntity>> searchNews(String query);

  // Cached on-demand — news detail
  Future<KhNewsDetailEntity?> getNewsDetail(String slug);
  Future<void> syncNewsDetail(String slug);

  // Direct remote (no cache)
  Future<KhReportResponseEntity?> submitReport({
    required String nama,
    required String email,
    required String noHp,
    required String isiLaporan,
    String? linkBukti,
    File? gambarBukti,
  });
  Future<KhTrackReportEntity?> trackReport(String ticketNumber);
}
