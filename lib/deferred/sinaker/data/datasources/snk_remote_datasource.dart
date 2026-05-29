import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zstandard/zstandard.dart';
import '../../../../main/data/datasources/decompression.dart';
import '../models/dto/blk/blk_dto.dart';
import '../models/dto/kejuruan/kejuruan_dto.dart';
import '../models/dto/wilayah/wilayah_dto.dart';
import '../models/dto/pendaftaran/pendaftaran_dto.dart';

abstract class SnkRemoteDatasource {
  Future<List<String>?> fetchKotaList();
  Future<List<BlkDto>?> fetchBlkList({String kota = ''});
  Future<List<KejuruanDto>?> fetchKejuruanList({required int blkId});
  Future<List<WilayahDto>?> fetchProvinsiList();
  Future<List<WilayahDto>?> fetchKabKotaList({required String idProvinsi});
  Future<List<WilayahDto>?> fetchKecamatanList({required String idKabKota});
  Future<List<WilayahDto>?> fetchDesaList({required String idKecamatan});
  Future<PendaftaranResultDto?> submitPendaftaran({
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
  Future<List<StatusPendaftaranDto>?> cekStatus({
    required String nik,
    required String noWa,
  });
}

class SnkRemoteDatasourceImpl implements SnkRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  SnkRemoteDatasourceImpl({required this.dio, this.zstandard});

  static const String _basePrefix = '/sinaker';

  @override
  Future<List<String>?> fetchKotaList() async {
    try {
      final response = await dio.get('$_basePrefix/public/kota');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List).cast<String>();
    } catch (e) {
      throw Exception('Failed to fetch kota list: $e');
    }
  }

  @override
  Future<List<BlkDto>?> fetchBlkList({String kota = ''}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (kota.isNotEmpty) queryParams['kota'] = kota;

      final response = await dio.get(
        '$_basePrefix/public/blk',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => BlkDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch BLK list: $e');
    }
  }

  @override
  Future<List<KejuruanDto>?> fetchKejuruanList({required int blkId}) async {
    try {
      final response = await dio.get('$_basePrefix/public/blk/$blkId/kejuruan');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => KejuruanDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kejuruan list: $e');
    }
  }

  @override
  Future<List<WilayahDto>?> fetchProvinsiList() async {
    try {
      final response = await dio.get('$_basePrefix/public/wilayah/provinsi');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => WilayahDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch provinsi list: $e');
    }
  }

  @override
  Future<List<WilayahDto>?> fetchKabKotaList({required String idProvinsi}) async {
    try {
      final response = await dio.get('$_basePrefix/public/wilayah/kab-kota/$idProvinsi');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => WilayahDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kab/kota list: $e');
    }
  }

  @override
  Future<List<WilayahDto>?> fetchKecamatanList({required String idKabKota}) async {
    try {
      final response = await dio.get('$_basePrefix/public/wilayah/kecamatan/$idKabKota');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => WilayahDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kecamatan list: $e');
    }
  }

  @override
  Future<List<WilayahDto>?> fetchDesaList({required String idKecamatan}) async {
    try {
      final response = await dio.get('$_basePrefix/public/wilayah/desa/$idKecamatan');

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => WilayahDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch desa list: $e');
    }
  }

  @override
  Future<PendaftaranResultDto?> submitPendaftaran({
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
  }) async {
    try {
      final fileName = foto.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final formData = FormData.fromMap({
        'blk_id': blkId,
        'kejuruan_id': kejuruanId,
        'nik': nik,
        'nama_lengkap': namaLengkap,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'email': email,
        'jenis_kelamin': jenisKelamin,
        'provinsi': provinsi,
        'kab_kota': kabKota,
        'kecamatan': kecamatan,
        'rt': rt,
        'rw': rw,
        'alamat_lengkap': alamatLengkap,
        'no_wa': noWa,
        'no_wa_darurat': noWaDarurat,
        'pendidikan_terakhir': pendidikanTerakhir,
        'pendidikan_sekarang': pendidikanSekarang,
        'penyandang_disabilitas': penyandangDisabilitas,
        'foto': await MultipartFile.fromFile(
          foto.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        '$_basePrefix/public/pendaftaran',
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return PendaftaranResultDto.fromJson(data["data"]);
    } catch (e) {
      throw Exception('Failed to submit pendaftaran: $e');
    }
  }

  @override
  Future<List<StatusPendaftaranDto>?> cekStatus({
    required String nik,
    required String noWa,
  }) async {
    try {
      final response = await dio.post(
        '$_basePrefix/public/cek-status',
        data: {
          'nik': nik,
          'no_wa': noWa,
        },
      );

      if (response.statusCode != 200) return null;

      final data = await cleanupData(response: response, zstandard: zstandard);

      if (data["data"] == null) return null;

      return (data["data"] as List)
          .map((json) => StatusPendaftaranDto.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to check status: $e');
    }
  }
}
