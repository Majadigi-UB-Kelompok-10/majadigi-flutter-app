import 'dart:io';

import '../entities/blk/snk_blk_entity.dart';
import '../entities/kejuruan/snk_kejuruan_entity.dart';
import '../entities/wilayah/snk_wilayah_entity.dart';
import '../entities/pendaftaran/snk_pendaftaran_entity.dart';

abstract class SnkRepository {
  // BLK (cached via Isar, SWR pattern)
  Stream<List<SnkBlkEntity>> getBlkList();
  Future<void> syncBlkList();

  // Kota list (simple string list from API, no cache)
  Future<List<String>> getKotaList();

  // Kejuruan (parameter-dependent, no cache)
  Future<List<SnkKejuruanEntity>> getKejuruanList({required int blkId});

  // Wilayah (parameter-dependent cascading dropdowns, no cache)
  Future<List<SnkWilayahEntity>> getProvinsiList();
  Future<List<SnkWilayahEntity>> getKabKotaList({required String idProvinsi});
  Future<List<SnkWilayahEntity>> getKecamatanList({required String idKabKota});
  Future<List<SnkWilayahEntity>> getDesaList({required String idKecamatan});

  // Pendaftaran (POST, no cache)
  Future<SnkPendaftaranResultEntity> submitPendaftaran({
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
  });

  // Cek Status (POST, no cache)
  Future<List<SnkStatusPendaftaranEntity>> cekStatus({
    required String nik,
    required String noWa,
  });
}
