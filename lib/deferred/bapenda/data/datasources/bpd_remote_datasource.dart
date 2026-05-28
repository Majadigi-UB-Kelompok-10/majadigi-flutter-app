import 'package:dio/dio.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:zstandard/zstandard.dart';

import '../models/dto/njkb/njkb_kalkulasi_dto.dart';
import '../models/dto/pajak/pajak_info_dto.dart';

/// Contract for Bapenda's remote data source.
abstract class BpdRemoteDatasource {
  // Pajak
  Future<PajakInfoDto> fetchPajakInfo({
    required String platNomor,
    required String nomorRangka,
  });

  // NJKB cascading options
  Future<List<String>> fetchJenis();
  Future<List<String>> fetchMerk({required String jenis});
  Future<List<String>> fetchModel({required String jenis, required String merk});
  Future<List<String>> fetchTipe({
    required String jenis,
    required String merk,
    required String model,
  });
  Future<List<int>> fetchTahun({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
  });

  // NJKB kalkulasi
  Future<NjkbKalkulasiDto> fetchKalkulasi({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  });
}

/// Implementation using Dio + Zstandard decompression.
class BpdRemoteDatasourceImpl implements BpdRemoteDatasource {
  final Dio _dio;
  final Zstandard _zstandard;

  BpdRemoteDatasourceImpl({required Dio dio, required Zstandard zstandard})
      : _dio = dio,
        _zstandard = zstandard;

  // ── Pajak ──────────────────────────────────────────────────────

  @override
  Future<PajakInfoDto> fetchPajakInfo({
    required String platNomor,
    required String nomorRangka,
  }) async {
    final response = await _dio.post(
      '/bapenda/pajak/info',
      data: FormData.fromMap({
        'plat_nomor': platNomor,
        'nomor_rangka': nomorRangka,
      }),
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return PajakInfoDto.fromJson(data as Map<String, dynamic>);
  }

  // ── NJKB Cascading Options ─────────────────────────────────────

  @override
  Future<List<String>> fetchJenis() async {
    final response = await _dio.get('/bapenda/njkb/jenis');
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return (data as List).cast<String>();
  }

  @override
  Future<List<String>> fetchMerk({required String jenis}) async {
    final response = await _dio.get(
      '/bapenda/njkb/merk',
      queryParameters: {'jenis': jenis},
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return (data as List).cast<String>();
  }

  @override
  Future<List<String>> fetchModel({
    required String jenis,
    required String merk,
  }) async {
    final response = await _dio.get(
      '/bapenda/njkb/model',
      queryParameters: {'jenis': jenis, 'merk': merk},
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return (data as List).cast<String>();
  }

  @override
  Future<List<String>> fetchTipe({
    required String jenis,
    required String merk,
    required String model,
  }) async {
    final response = await _dio.get(
      '/bapenda/njkb/tipe',
      queryParameters: {'jenis': jenis, 'merk': merk, 'model': model},
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return (data as List).cast<String>();
  }

  @override
  Future<List<int>> fetchTahun({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
  }) async {
    final response = await _dio.get(
      '/bapenda/njkb/tahun',
      queryParameters: {
        'jenis': jenis,
        'merk': merk,
        'model': model,
        'tipe': tipe,
      },
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return (data as List).cast<int>();
  }

  // ── NJKB Kalkulasi ─────────────────────────────────────────────

  @override
  Future<NjkbKalkulasiDto> fetchKalkulasi({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  }) async {
    final response = await _dio.post(
      '/bapenda/njkb/kalkulasi',
      data: {
        'jenis': jenis,
        'merk': merk,
        'model': model,
        'tipe': tipe,
        'tahun': tahun,
      },
    );
    final data = await cleanupData(zstandard: _zstandard, response: response);
    return NjkbKalkulasiDto.fromJson(data as Map<String, dynamic>);
  }
}
