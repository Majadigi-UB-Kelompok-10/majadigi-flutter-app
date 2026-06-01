import 'dart:io';

import '../../domain/entities/blk/snk_blk_entity.dart';
import '../../domain/entities/kejuruan/snk_kejuruan_entity.dart';
import '../../domain/entities/wilayah/snk_wilayah_entity.dart';
import '../../domain/entities/pendaftaran/snk_pendaftaran_entity.dart';
import '../../domain/repositories/snk_repository.dart';
import '../datasources/snk_local_datasource.dart';
import '../datasources/snk_remote_datasource.dart';
import '../models/dto/blk/blk_dto.dart';
import '../models/isar/blk/snk_blk_registry.dart';

// ---------------------------------------------------------------------------
// DTO → Isar Registry Mapping Extensions
// ---------------------------------------------------------------------------

extension BlkDtoToIsar on BlkDto {
  IsarSnkBlkRegistry toIsar() {
    return IsarSnkBlkRegistry()
      ..blkId = id
      ..nama = nama ?? ''
      ..alamat = alamat ?? ''
      ..kabKota = kabKota ?? ''
      ..kecamatan = kecamatan ?? ''
      ..slug = slug ?? ''
      ..lat = lat
      ..lng = lng;
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class SnkRepositoryImpl implements SnkRepository {
  final SnkLocalDatasource local;
  final SnkRemoteDatasource remote;

  SnkRepositoryImpl({required this.local, required this.remote});

  // -- BLK (SWR cached) --

  @override
  Stream<List<SnkBlkEntity>> getBlkList() {
    return local.watchBlkList().map(
      (list) => list.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Future<void> syncBlkList() async {
    try {
      final dtos = await remote.fetchBlkList();
      if (dtos == null || dtos.isEmpty) return;

      final registries = dtos.map((d) => d.toIsar()).toList();
      await local.saveBlkList(registries);
    } catch (e) {
      // Silently fail — cached data still available
    }
  }

  // -- Kota (direct fetch) --

  @override
  Future<List<String>> getKotaList() async {
    final result = await remote.fetchKotaList();
    return result ?? [];
  }

  // -- Kejuruan (direct fetch) --

  @override
  Future<List<SnkKejuruanEntity>> getKejuruanList({required int blkId}) async {
    final dtos = await remote.fetchKejuruanList(blkId: blkId);
    if (dtos == null) return [];

    return dtos
        .map((d) => SnkKejuruanEntity(
              id: d.id,
              nama: d.nama ?? '',
            ))
        .toList();
  }

  // -- Wilayah (direct fetch) --

  @override
  Future<List<SnkWilayahEntity>> getProvinsiList() async {
    final dtos = await remote.fetchProvinsiList();
    if (dtos == null) return [];

    return dtos.map(_wilayahDtoToEntity).toList();
  }

  @override
  Future<List<SnkWilayahEntity>> getKabKotaList({required String idProvinsi}) async {
    final dtos = await remote.fetchKabKotaList(idProvinsi: idProvinsi);
    if (dtos == null) return [];

    return dtos.map(_wilayahDtoToEntity).toList();
  }

  @override
  Future<List<SnkWilayahEntity>> getKecamatanList({required String idKabKota}) async {
    final dtos = await remote.fetchKecamatanList(idKabKota: idKabKota);
    if (dtos == null) return [];

    return dtos.map(_wilayahDtoToEntity).toList();
  }

  @override
  Future<List<SnkWilayahEntity>> getDesaList({required String idKecamatan}) async {
    final dtos = await remote.fetchDesaList(idKecamatan: idKecamatan);
    if (dtos == null) return [];

    return dtos.map(_wilayahDtoToEntity).toList();
  }

  SnkWilayahEntity _wilayahDtoToEntity(dynamic dto) {
    return SnkWilayahEntity(
      id: dto.id,
      nama: dto.nama ?? '',
      latitude: dto.latitude,
      longitude: dto.longitude,
    );
  }

  // -- Pendaftaran (POST) --

  @override
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
    required String kelurahan,
    required String asalSekolah,
    required String jurusan,
    required String rt,
    required String rw,
    required String alamatLengkap,
    required String noWa,
    required String noWaDarurat,
    required String pendidikanTerakhir,
    required String pendidikanSekarang,
    required bool penyandangDisabilitas,
    required File foto,
  }) async {
    final dto = await remote.submitPendaftaran(
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
      asalSekolah: asalSekolah,
      jurusan: jurusan,
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

    if (dto == null) {
      throw Exception('Pendaftaran gagal: response kosong');
    }

    return SnkPendaftaranResultEntity(
      id: dto.id,
      status: dto.status ?? '',
      createdAt: dto.createdAt ?? '',
    );
  }

  // -- Cek Status (POST) --

  @override
  Future<List<SnkStatusPendaftaranEntity>> cekStatus({
    required String nik,
    required String noWa,
  }) async {
    final dtos = await remote.cekStatus(nik: nik, noWa: noWa);
    if (dtos == null) return [];

    return dtos
        .map((d) => SnkStatusPendaftaranEntity(
              id: d.id,
              blkNama: d.blkNama ?? '',
              blkSlug: d.blkSlug ?? '',
              kejuruanNama: d.kejuruanNama ?? '',
              status: d.status ?? '',
              tanggalDaftar: d.tanggalDaftar ?? '',
            ))
        .toList();
  }
}
