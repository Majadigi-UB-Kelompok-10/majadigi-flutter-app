import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../domain/repositories/kh_repository.dart';
import '../../domain/usecase/kh_use_cases.dart';
import '../../domain/entities/stat/kh_stat_entity.dart';
import '../../domain/entities/news/kh_news_entity.dart';
import '../../domain/entities/news/kh_news_detail_entity.dart';
import '../../domain/entities/report/kh_report_response_entity.dart';
import '../../domain/entities/report/kh_track_report_entity.dart';
import '../../data/datasources/kh_local_datasource.dart';
import '../../data/datasources/kh_remote_datasource.dart';
import '../../data/repositories/kh_repository_impl.dart';

part 'kh_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
Future<KhLocalDatasource> _khLocalDatasource(Ref ref) async {
  final isar = await ref.watch(khIsarDbProvider.future);
  return KhLocalDatasourceImpl(isar);
}

@riverpod
KhRemoteDatasource _khRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return KhRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
Future<KhRepository> _khRepository(Ref ref) async {
  final local = await ref.watch(_khLocalDatasourceProvider.future);
  final remote = ref.watch(_khRemoteDatasourceProvider);
  return KhRepositoryImpl(local: local, remote: remote);
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
Future<GetKhStatsUseCase> _getKhStatsUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return GetKhStatsUseCase(repo);
}

@riverpod
Future<GetKhNewsUseCase> _getKhNewsUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return GetKhNewsUseCase(repo);
}

@riverpod
Future<SearchKhNewsUseCase> _searchKhNewsUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return SearchKhNewsUseCase(repo);
}

@riverpod
Future<GetKhNewsDetailUseCase> _getKhNewsDetailUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return GetKhNewsDetailUseCase(repo);
}

@riverpod
Future<SubmitKhReportUseCase> _submitKhReportUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return SubmitKhReportUseCase(repo);
}

@riverpod
Future<TrackKhReportUseCase> _trackKhReportUseCase(Ref ref) async {
  final repo = await ref.watch(_khRepositoryProvider.future);
  return TrackKhReportUseCase(repo);
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public)
// ---------------------------------------------------------------------------

/// Stream of all stats (SWR — fires sync, streams from cache)
@riverpod
Stream<List<KhStatEntity>> khStats(Ref ref) async* {
  final usecase = await ref.watch(_getKhStatsUseCaseProvider.future);
  yield* usecase.call();
}

/// Stream of all news (SWR — fires sync, streams from cache)
@riverpod
Stream<List<KhNewsEntity>> khNews(Ref ref) async* {
  final usecase = await ref.watch(_getKhNewsUseCaseProvider.future);
  yield* usecase.call();
}

/// Stream of news filtered by search query (local Isar filter)
@riverpod
Stream<List<KhNewsEntity>> khNewsSearch(Ref ref, {required String query}) async* {
  final usecase = await ref.watch(_searchKhNewsUseCaseProvider.future);
  yield* usecase.call(query);
}

/// Fetch news detail by slug (cached on-demand)
@riverpod
Future<KhNewsDetailEntity?> khNewsDetail(Ref ref, {required String slug}) async {
  final usecase = await ref.watch(_getKhNewsDetailUseCaseProvider.future);
  return await usecase.call(slug);
}

/// Submit a report (direct remote)
@riverpod
Future<KhReportResponseEntity?> khSubmitReport(
  Ref ref, {
  required String nama,
  required String email,
  required String noHp,
  required String isiLaporan,
  String? linkBukti,
  File? gambarBukti,
}) async {
  final usecase = await ref.watch(_submitKhReportUseCaseProvider.future);
  return await usecase.call(
    nama: nama,
    email: email,
    noHp: noHp,
    isiLaporan: isiLaporan,
    linkBukti: linkBukti,
    gambarBukti: gambarBukti,
  );
}

/// Track a report by ticket number (direct remote)
@riverpod
Future<KhTrackReportEntity?> khTrackReport(Ref ref, {required String ticketNumber}) async {
  final usecase = await ref.watch(_trackKhReportUseCaseProvider.future);
  return await usecase.call(ticketNumber);
}
