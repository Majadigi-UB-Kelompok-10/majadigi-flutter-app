import '../entities/pajak/bpd_pajak_entity.dart';
import '../entities/njkb/bpd_njkb_entity.dart';

/// Contract for Bapenda module's data operations.
/// Implementation lives in data/repositories/bpd_repository_impl.dart
abstract class BpdRepository {
  // Pajak
  Future<BpdPajakEntity> getPajakInfo({
    required String platNomor,
    required String nomorRangka,
  });

  // NJKB cascading options
  Future<List<String>> getJenis();
  Future<List<String>> getMerk({required String jenis});
  Future<List<String>> getModel({required String jenis, required String merk});
  Future<List<String>> getTipe({
    required String jenis,
    required String merk,
    required String model,
  });
  Future<List<int>> getTahun({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
  });

  // NJKB kalkulasi
  Future<BpdNjkbKalkulasiEntity> postKalkulasi({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  });
}
