import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../data/datasources/bansos_local_datasource.dart';
import '../../data/datasources/bansos_remote_datasource.dart';
import '../../data/repositories/bansos_repository_impl.dart';
import '../../domain/repositories/bansos_repository.dart';
import '../../domain/usecase/bansos_use_cases.dart';
import '../../domain/entities/bansos/bansos_entity.dart';

part 'bansos_providers.g.dart';

@riverpod
BansosLocalDatasource _bansosLocalDatasource(Ref ref) {
  final isar = ref.watch(bansosIsarProvider).requireValue;
  return BansosLocalDatasourceImpl(isar);
}

@riverpod
BansosRemoteDatasource _bansosRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return BansosRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

@riverpod
BansosRepository _bansosRepository(Ref ref) {
  return BansosRepositoryImpl(
    localDatasource: ref.watch(_bansosLocalDatasourceProvider),
    remoteDatasource: ref.watch(_bansosRemoteDatasourceProvider),
  );
}

@riverpod
GetBansosUseCase _getBansosUseCase(Ref ref) {
  return GetBansosUseCase(ref.watch(_bansosRepositoryProvider));
}

@riverpod
WatchBansosUseCase _watchBansosUseCase(Ref ref) {
  return WatchBansosUseCase(ref.watch(_bansosRepositoryProvider));
}

@riverpod
Future<BansosEntity?> bansosInfo(Ref ref, String nik) {
  final useCase = ref.watch(_getBansosUseCaseProvider);
  return useCase.execute(nik);
}

@riverpod
Stream<List<BansosEntity>> watchBansosInfo(Ref ref, String nik) async* {
  final useCase = ref.watch(_watchBansosUseCaseProvider);
  yield* useCase.execute(nik);
}