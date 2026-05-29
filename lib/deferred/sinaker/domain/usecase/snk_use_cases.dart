import 'dart:io';

import '../entities/blk/snk_blk_entity.dart';
import '../entities/kejuruan/snk_kejuruan_entity.dart';
import '../entities/wilayah/snk_wilayah_entity.dart';
import '../entities/pendaftaran/snk_pendaftaran_entity.dart';
import '../repositories/snk_repository.dart';

// ---------------------------------------------------------------------------
// BLK Use Cases (SWR cached)
// ---------------------------------------------------------------------------

class GetSnkBlkListUseCase {
  final SnkRepository repository;
  GetSnkBlkListUseCase(this.repository);

  Stream<List<SnkBlkEntity>> call() {
    repository.syncBlkList();
    return repository.getBlkList();
  }
}

// ---------------------------------------------------------------------------
// Kota Use Case (direct fetch, no cache)
// ---------------------------------------------------------------------------

class GetSnkKotaListUseCase {
  final SnkRepository repository;
  GetSnkKotaListUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getKotaList();
  }
}

// ---------------------------------------------------------------------------
// Kejuruan Use Case (parameter-dependent, no cache)
// ---------------------------------------------------------------------------

class GetSnkKejuruanListUseCase {
  final SnkRepository repository;
  GetSnkKejuruanListUseCase(this.repository);

  Future<List<SnkKejuruanEntity>> call({required int blkId}) {
    return repository.getKejuruanList(blkId: blkId);
  }
}

// ---------------------------------------------------------------------------
// Wilayah Use Cases (parameter-dependent cascading, no cache)
// ---------------------------------------------------------------------------

class GetSnkProvinsiListUseCase {
  final SnkRepository repository;
  GetSnkProvinsiListUseCase(this.repository);

  Future<List<SnkWilayahEntity>> call() {
    return repository.getProvinsiList();
  }
}

class GetSnkKabKotaListUseCase {
  final SnkRepository repository;
  GetSnkKabKotaListUseCase(this.repository);

  Future<List<SnkWilayahEntity>> call({required String idProvinsi}) {
    return repository.getKabKotaList(idProvinsi: idProvinsi);
  }
}

class GetSnkKecamatanListUseCase {
  final SnkRepository repository;
  GetSnkKecamatanListUseCase(this.repository);

  Future<List<SnkWilayahEntity>> call({required String idKabKota}) {
    return repository.getKecamatanList(idKabKota: idKabKota);
  }
}

class GetSnkDesaListUseCase {
  final SnkRepository repository;
  GetSnkDesaListUseCase(this.repository);

  Future<List<SnkWilayahEntity>> call({required String idKecamatan}) {
    return repository.getDesaList(idKecamatan: idKecamatan);
  }
}

// ---------------------------------------------------------------------------
// Pendaftaran Use Cases (POST, no cache)
// ---------------------------------------------------------------------------

class SubmitSnkPendaftaranUseCase {
  final SnkRepository repository;
  SubmitSnkPendaftaranUseCase(this.repository);

  Future<SnkPendaftaranResultEntity> call({
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
    required String rt,
    required String rw,
    required String alamatLengkap,
    required String noWa,
    required String noWaDarurat,
    required String pendidikanTerakhir,
    required String pendidikanSekarang,
    required bool penyandangDisabilitas,
    required File foto,
  }) {
    return repository.submitPendaftaran(
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
      rt: rt,
      rw: rw,
      alamatLengkap: alamatLengkap,
      noWa: noWa,
      noWaDarurat: noWaDarurat,
      pendidikanTerakhir: pendidikanTerakhir,
      pendidikanSekarang: pendidikanSekarang,
      penyandangDisabilitas: penyandangDisabilitas,
      foto: foto,
    );
  }
}

class CekSnkStatusUseCase {
  final SnkRepository repository;
  CekSnkStatusUseCase(this.repository);

  Future<List<SnkStatusPendaftaranEntity>> call({
    required String nik,
    required String noWa,
  }) {
    return repository.cekStatus(nik: nik, noWa: noWa);
  }
}
