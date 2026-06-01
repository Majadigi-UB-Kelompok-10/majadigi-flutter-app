import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../main/core/http.dart';
import '../storage.dart';
import '../../domain/entities/blk/snk_blk_entity.dart';
import '../../domain/entities/kejuruan/snk_kejuruan_entity.dart';
import '../../domain/entities/wilayah/snk_wilayah_entity.dart';
import '../../domain/entities/pendaftaran/snk_pendaftaran_entity.dart';
import '../../domain/repositories/snk_repository.dart';
import '../../domain/usecase/snk_use_cases.dart';
import '../../data/datasources/snk_local_datasource.dart';
import '../../data/datasources/snk_remote_datasource.dart';
import '../../data/repositories/snk_repository_impl.dart';

part 'snk_providers.g.dart';

// ---------------------------------------------------------------------------
// Datasources (private)
// ---------------------------------------------------------------------------

@riverpod
Future<SnkLocalDatasource> _snkLocalDatasource(Ref ref) async {
  final isar = await ref.watch(snkIsarDbProvider.future);
  return SnkLocalDatasourceImpl(isar);
}

@riverpod
SnkRemoteDatasource _snkRemoteDatasource(Ref ref) {
  final dio = ref.watch(dioProvider);
  final zstandard = ref.watch(zstandardProvider);
  return SnkRemoteDatasourceImpl(dio: dio, zstandard: zstandard);
}

// ---------------------------------------------------------------------------
// Repository (private)
// ---------------------------------------------------------------------------

@riverpod
Future<SnkRepository> _snkRepository(Ref ref) async {
  final local = await ref.watch(_snkLocalDatasourceProvider.future);
  final remote = ref.watch(_snkRemoteDatasourceProvider);
  return SnkRepositoryImpl(local: local, remote: remote);
}

// ---------------------------------------------------------------------------
// Use Cases (private)
// ---------------------------------------------------------------------------

@riverpod
Future<GetSnkBlkListUseCase> _getSnkBlkListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkBlkListUseCase(repo);
}

@riverpod
Future<GetSnkKotaListUseCase> _getSnkKotaListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkKotaListUseCase(repo);
}

@riverpod
Future<GetSnkKejuruanListUseCase> _getSnkKejuruanListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkKejuruanListUseCase(repo);
}

@riverpod
Future<GetSnkProvinsiListUseCase> _getSnkProvinsiListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkProvinsiListUseCase(repo);
}

@riverpod
Future<GetSnkKabKotaListUseCase> _getSnkKabKotaListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkKabKotaListUseCase(repo);
}

@riverpod
Future<GetSnkKecamatanListUseCase> _getSnkKecamatanListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkKecamatanListUseCase(repo);
}

@riverpod
Future<GetSnkDesaListUseCase> _getSnkDesaListUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return GetSnkDesaListUseCase(repo);
}

@riverpod
Future<SubmitSnkPendaftaranUseCase> _submitSnkPendaftaranUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return SubmitSnkPendaftaranUseCase(repo);
}

@riverpod
Future<CekSnkStatusUseCase> _cekSnkStatusUseCase(Ref ref) async {
  final repo = await ref.watch(_snkRepositoryProvider.future);
  return CekSnkStatusUseCase(repo);
}

// ---------------------------------------------------------------------------
// Exposed Data Providers (public — consumed by presentation layer)
// ---------------------------------------------------------------------------

/// Stream of BLK list (SWR cached)
@riverpod
Stream<List<SnkBlkEntity>> snkBlkList(Ref ref) async* {
  final usecase = await ref.watch(_getSnkBlkListUseCaseProvider.future);
  yield* usecase.call();
}

/// Kota list (direct fetch)
@riverpod
Future<List<String>> snkKotaList(Ref ref) async {
  final usecase = await ref.watch(_getSnkKotaListUseCaseProvider.future);
  return usecase.call();
}

/// Kejuruan list per BLK (direct fetch)
@riverpod
Future<List<SnkKejuruanEntity>> snkKejuruanList(Ref ref, {required int blkId}) async {
  final usecase = await ref.watch(_getSnkKejuruanListUseCaseProvider.future);
  return usecase.call(blkId: blkId);
}

/// Provinsi list (direct fetch)
@riverpod
Future<List<SnkWilayahEntity>> snkProvinsiList(Ref ref) async {
  final usecase = await ref.watch(_getSnkProvinsiListUseCaseProvider.future);
  return usecase.call();
}

/// Kab/Kota list per provinsi (direct fetch)
@riverpod
Future<List<SnkWilayahEntity>> snkKabKotaList(Ref ref, {required String idProvinsi}) async {
  final usecase = await ref.watch(_getSnkKabKotaListUseCaseProvider.future);
  return usecase.call(idProvinsi: idProvinsi);
}

/// Kecamatan list per kab/kota (direct fetch)
@riverpod
Future<List<SnkWilayahEntity>> snkKecamatanList(Ref ref, {required String idKabKota}) async {
  final usecase = await ref.watch(_getSnkKecamatanListUseCaseProvider.future);
  return usecase.call(idKabKota: idKabKota);
}

/// Desa list per kecamatan (direct fetch)
@riverpod
Future<List<SnkWilayahEntity>> snkDesaList(Ref ref, {required String idKecamatan}) async {
  final usecase = await ref.watch(_getSnkDesaListUseCaseProvider.future);
  return usecase.call(idKecamatan: idKecamatan);
}

/// Submit pendaftaran (action provider)
@riverpod
Future<SnkPendaftaranResultEntity> snkSubmitPendaftaran(
  Ref ref, {
  required int blkId,
  required int kejuruanId,
  required String nik,
  required String namaLengkap,
  required String tempatLahir,
  required String tanggalLahir,
  required String email,
  required String jenisKelamin,
  required String provinsi,
  required String kabKota,
  required String kecamatan,
  required String kelurahan,
  required String rt,
  required String rw,
  required String alamatLengkap,
  required String asalSekolah,
  required String jurusan,
  required String noWa,
  required String noWaDarurat,
  required String pendidikanTerakhir,
  required String pendidikanSekarang,
  required bool penyandangDisabilitas,
  required File foto,
}) async {
  final usecase = await ref.watch(_submitSnkPendaftaranUseCaseProvider.future);
  return usecase.call(
    blkId: blkId,
    kejuruanId: kejuruanId,
    nik: nik,
    namaLengkap: namaLengkap,
    tempatLahir: tempatLahir,
    tanggalLahir: tanggalLahir,
    email: email,
    jenisKelamin: jenisKelamin,
    provinsi: provinsi,
    kabKota: kabKota,
    kecamatan: kecamatan,
    kelurahan: kelurahan,
    rt: rt,
    rw: rw,
    alamatLengkap: alamatLengkap,
    asalSekolah: asalSekolah,
    jurusan: jurusan,
    noWa: noWa,
    noWaDarurat: noWaDarurat,
    pendidikanTerakhir: pendidikanTerakhir,
    pendidikanSekarang: pendidikanSekarang,
    penyandangDisabilitas: penyandangDisabilitas,
    foto: foto,
  );
}

/// Check registration status (action provider)
@riverpod
Future<List<SnkStatusPendaftaranEntity>> snkCekStatus(
  Ref ref, {
  required String nik,
  required String noWa,
}) async {
  final usecase = await ref.watch(_cekSnkStatusUseCaseProvider.future);
  return usecase.call(nik: nik, noWa: noWa);
}
