import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../domain/repositories/rssa_repository.dart';
import '../../domain/usecase/rssa_use_cases.dart';
import '../../domain/entities/summary/rssa_summary_entity.dart';
import '../../domain/entities/kelas/rssa_kelas_entity.dart';
import '../../domain/entities/ruangan/rssa_ruangan_entity.dart';
import '../../data/datasources/rssa_local_datasource.dart';
import '../../data/datasources/rssa_remote_datasource.dart';
import '../../data/repositories/rssa_repository_impl.dart';

part 'rssa_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
Future<RssaLocalDatasource> _rssaLocalDatasource(Ref ref) async {
  final isar = await ref.watch(rssaIsarDbProvider.future);
  return RssaLocalDatasourceImpl(isar);
}

@riverpod
RssaRemoteDatasource _rssaRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return RssaRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
Future<RssaRepository> _rssaRepository(Ref ref) async {
  final local = await ref.watch(_rssaLocalDatasourceProvider.future);
  final remote = ref.watch(_rssaRemoteDatasourceProvider);
  return RssaRepositoryImpl(local: local, remote: remote);
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
Future<GetRssaSummaryUseCase> _getRssaSummaryUseCase(Ref ref) async {
  final repo = await ref.watch(_rssaRepositoryProvider.future);
  return GetRssaSummaryUseCase(repo);
}

@riverpod
Future<GetRssaKelasUseCase> _getRssaKelasUseCase(Ref ref) async {
  final repo = await ref.watch(_rssaRepositoryProvider.future);
  return GetRssaKelasUseCase(repo);
}

@riverpod
Future<GetRssaRuanganUseCase> _getRssaRuanganUseCase(Ref ref) async {
  final repo = await ref.watch(_rssaRepositoryProvider.future);
  return GetRssaRuanganUseCase(repo);
}

@riverpod
Future<GetRssaRuanganLocalUseCase> _getRssaRuanganLocalUseCase(Ref ref) async {
  final repo = await ref.watch(_rssaRepositoryProvider.future);
  return GetRssaRuanganLocalUseCase(repo);
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public)
// ---------------------------------------------------------------------------

@riverpod
Stream<RssaSummaryEntity?> rssaSummary(Ref ref) async* {
  final usecase = await ref.watch(_getRssaSummaryUseCaseProvider.future);
  yield* usecase.call();
}

@riverpod
Stream<List<RssaKelasEntity>> rssaKelas(Ref ref) async* {
  final usecase = await ref.watch(_getRssaKelasUseCaseProvider.future);
  yield* usecase.call();
}

@riverpod
Stream<List<RssaRuanganEntity>> rssaRuangan(Ref ref, {String search = '', String kelas = ''}) async* {
  final usecase = await ref.watch(_getRssaRuanganUseCaseProvider.future);
  yield* usecase.call(search: search, kelas: kelas);
}

@riverpod
Stream<List<RssaRuanganEntity>> rssaRuanganLocal(Ref ref, {String search = '', String kelas = ''}) async* {
  final usecase = await ref.watch(_getRssaRuanganLocalUseCaseProvider.future);
  yield* usecase.call(search: search, kelas: kelas);
}
