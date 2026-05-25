import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../domain/repositories/skp_repository.dart';
import '../../domain/usecase/skp_use_cases.dart';
import '../../domain/entities/area/skp_area_entity.dart';
import '../../domain/entities/bahan_pokok/skp_bahan_pokok_entity.dart';
import '../../domain/entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';
import '../../data/datasources/skp_local_datasource.dart';
import '../../data/datasources/skp_remote_datasource.dart';
import '../../data/repositories/skp_repository_impl.dart';

part 'skp_providers.g.dart';

@riverpod
Future<SkpLocalDatasource> _skpLocalDatasource(Ref ref) async {
  final isar = await ref.watch(skpIsarDbProvider.future);
  return SkpLocalDatasourceImpl(isar);
}

@riverpod
SkpRemoteDatasource _skpRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return SkpRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

@riverpod
Future<SkpRepository> _skpRepository(Ref ref) async {
  final local = await ref.watch(_skpLocalDatasourceProvider.future);
  final remote = ref.watch(_skpRemoteDatasourceProvider);
  return SkpRepositoryImpl(local: local, remote: remote);
}

@riverpod
Future<GetSkpAreasUseCase> _getSkpAreasUseCase(Ref ref) async {
  final repo = await ref.watch(_skpRepositoryProvider.future);
  return GetSkpAreasUseCase(repo);
}

@riverpod
Future<GetSkpBahanPokokUseCase> _getSkpBahanPokokUseCase(Ref ref) async {
  final repo = await ref.watch(_skpRepositoryProvider.future);
  return GetSkpBahanPokokUseCase(repo);
}

@riverpod
Future<GetSkpDetailBahanPokokUseCase> _getSkpDetailBahanPokokUseCase(Ref ref) async {
  final repo = await ref.watch(_skpRepositoryProvider.future);
  return GetSkpDetailBahanPokokUseCase(repo);
}

@riverpod
Stream<List<SkpAreaEntity>> skpAreas(Ref ref) async* {
  final usecase = await ref.watch(_getSkpAreasUseCaseProvider.future);
  yield* usecase.call();
}

@riverpod
Stream<List<SkpBahanPokokEntity>> skpBahanPokokList(Ref ref, {String tanggal = '', String bahanPokok = '', String area = ''}) async* {
  final usecase = await ref.watch(_getSkpBahanPokokUseCaseProvider.future);
  yield* usecase.call(tanggal: tanggal, bahanPokok: bahanPokok, area: area);
}

@riverpod
Stream<SkpDetailBahanPokokEntity?> skpDetailBahanPokok(Ref ref, {required String slug, String tanggal = '', String area = ''}) async* {
  final usecase = await ref.watch(_getSkpDetailBahanPokokUseCaseProvider.future);
  yield* usecase.call(slug: slug, tanggal: tanggal, area: area);
}
