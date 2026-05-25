import '../../domain/entities/area/skp_area_entity.dart';
import '../../domain/entities/bahan_pokok/skp_bahan_pokok_entity.dart';
import '../../domain/entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';

abstract class SkpRepository {
  // SWR Pattern: Get cached data immediately, trigger sync in background
  Stream<List<SkpAreaEntity>> getAreas();
  Stream<List<SkpBahanPokokEntity>> getBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''});
  Stream<SkpDetailBahanPokokEntity?> getDetailBahanPokok({required String slug, String tanggal = '', String area = ''});

  // Background sync methods
  Future<void> syncAreas();
  Future<void> syncBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''});
  Future<void> syncDetailBahanPokok({required String slug, String tanggal = '', String area = ''});
}
