import 'package:majadigi_mobile_rebuild/deferred/bapenda/data/datasources/bpd_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/data/repositories/bpd_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/domain/repositories/bpd_repository.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/domain/usecase/bpd_use_cases.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bpd_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
BpdRemoteDatasource _bpdRemoteDatasource(Ref ref) {
  return BpdRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
BpdRepository _bpdRepository(Ref ref) {
  return BpdRepositoryImpl(
    remoteDatasource: ref.watch(_bpdRemoteDatasourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
GetPajakInfoUseCase _getPajakInfoUseCase(Ref ref) {
  return GetPajakInfoUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
GetJenisUseCase _getJenisUseCase(Ref ref) {
  return GetJenisUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
GetMerkUseCase _getMerkUseCase(Ref ref) {
  return GetMerkUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
GetModelUseCase _getModelUseCase(Ref ref) {
  return GetModelUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
GetTipeUseCase _getTipeUseCase(Ref ref) {
  return GetTipeUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
GetTahunUseCase _getTahunUseCase(Ref ref) {
  return GetTahunUseCase(ref.watch(_bpdRepositoryProvider));
}

@riverpod
PostKalkulasiUseCase _postKalkulasiUseCase(Ref ref) {
  return PostKalkulasiUseCase(ref.watch(_bpdRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Exposed Use Case Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

@riverpod
GetPajakInfoUseCase bpdGetPajakInfo(Ref ref) {
  return ref.watch(_getPajakInfoUseCaseProvider);
}

@riverpod
GetJenisUseCase bpdGetJenis(Ref ref) {
  return ref.watch(_getJenisUseCaseProvider);
}

@riverpod
GetMerkUseCase bpdGetMerk(Ref ref) {
  return ref.watch(_getMerkUseCaseProvider);
}

@riverpod
GetModelUseCase bpdGetModel(Ref ref) {
  return ref.watch(_getModelUseCaseProvider);
}

@riverpod
GetTipeUseCase bpdGetTipe(Ref ref) {
  return ref.watch(_getTipeUseCaseProvider);
}

@riverpod
GetTahunUseCase bpdGetTahun(Ref ref) {
  return ref.watch(_getTahunUseCaseProvider);
}

@riverpod
PostKalkulasiUseCase bpdPostKalkulasi(Ref ref) {
  return ref.watch(_postKalkulasiUseCaseProvider);
}
