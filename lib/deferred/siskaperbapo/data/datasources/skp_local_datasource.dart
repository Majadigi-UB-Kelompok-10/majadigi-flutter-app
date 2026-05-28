import 'package:isar_community/isar.dart';
import '../models/isar/area/skp_area_registry.dart';
import '../models/isar/bahan_pokok/skp_bahan_pokok_registry.dart';
import '../models/isar/bahan_pokok/skp_detail_bahan_pokok_registry.dart';

abstract class SkpLocalDatasource {
  Stream<List<IsarSkpAreaRegistry>> watchAreas();
  Stream<List<IsarSkpBahanPokokRegistry>> watchBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''});
  Stream<IsarSkpDetailBahanPokokRegistry?> watchDetailBahanPokok({required String slug, String tanggal = '', String area = ''});

  Future<void> saveAreas(List<IsarSkpAreaRegistry> areas);
  Future<void> saveBahanPokok(List<IsarSkpBahanPokokRegistry> bahanPokokList, {String tanggal = '', String bahanPokok = '', String area = ''});
  Future<void> saveDetailBahanPokok(IsarSkpDetailBahanPokokRegistry detail);
}

class SkpLocalDatasourceImpl implements SkpLocalDatasource {
  final Isar isar;
  SkpLocalDatasourceImpl(this.isar);

  @override
  Stream<List<IsarSkpAreaRegistry>> watchAreas() {
    return isar.isarSkpAreaRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<IsarSkpBahanPokokRegistry>> watchBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''}) {
    return isar.isarSkpBahanPokokRegistrys
        .filter()
        .queryTanggalEqualTo(tanggal)
        .and()
        .queryBahanPokokEqualTo(bahanPokok)
        .and()
        .queryAreaEqualTo(area)
        .watch(fireImmediately: true);
  }

  @override
  Stream<IsarSkpDetailBahanPokokRegistry?> watchDetailBahanPokok({required String slug, String tanggal = '', String area = ''}) {
    return isar.isarSkpDetailBahanPokokRegistrys
        .filter()
        .slugEqualTo(slug)
        .and()
        .queryTanggalEqualTo(tanggal)
        .and()
        .queryAreaEqualTo(area)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  @override
  Future<void> saveAreas(List<IsarSkpAreaRegistry> areas) async {
    await isar.writeTxn(() async {
      await isar.isarSkpAreaRegistrys.clear();
      await isar.isarSkpAreaRegistrys.putAll(areas);
    });
  }

  @override
  Future<void> saveBahanPokok(List<IsarSkpBahanPokokRegistry> bahanPokokList, {String tanggal = '', String bahanPokok = '', String area = ''}) async {
    await isar.writeTxn(() async {
      await isar.isarSkpBahanPokokRegistrys
          .filter()
          .queryTanggalEqualTo(tanggal)
          .and()
          .queryBahanPokokEqualTo(bahanPokok)
          .and()
          .queryAreaEqualTo(area)
          .deleteAll();
      await isar.isarSkpBahanPokokRegistrys.putAll(bahanPokokList);
    });
  }

  @override
  Future<void> saveDetailBahanPokok(IsarSkpDetailBahanPokokRegistry detail) async {
    await isar.writeTxn(() async {
      await isar.isarSkpDetailBahanPokokRegistrys.putBySlugId(detail);
    });
  }
}
