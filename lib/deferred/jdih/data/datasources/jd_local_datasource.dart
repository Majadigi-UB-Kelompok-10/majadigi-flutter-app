import 'package:isar_community/isar.dart';
import '../models/isar/pengumuman/jd_pengumuman_registry.dart';
import '../models/isar/filter/jd_jenis_filter_registry.dart';

/// Contract for JDIH's local data source.
/// Uses Isar Database (separate instance from main).
abstract class JdLocalDatasource {
  // -- Pengumuman --
  Future<List<IsarJdPengumumanRegistry>> getCachedPengumuman();
  Stream<List<IsarJdPengumumanRegistry>> watchCachedPengumuman();
  Future<void> cachePengumuman(List<IsarJdPengumumanRegistry> items);

  // -- Jenis Filters --
  Future<List<IsarJdJenisFilterRegistry>> getCachedJenisFilters();
  Stream<List<IsarJdJenisFilterRegistry>> watchCachedJenisFilters();
  Future<void> cacheJenisFilters(List<IsarJdJenisFilterRegistry> items);
}

/// Implementation using Isar database.
class JdLocalDatasourceImpl implements JdLocalDatasource {
  final Isar _isar;
  JdLocalDatasourceImpl(this._isar);

  // -- Pengumuman --

  @override
  Future<List<IsarJdPengumumanRegistry>> getCachedPengumuman() {
    return _isar.isarJdPengumumanRegistrys.where().findAll();
  }

  @override
  Stream<List<IsarJdPengumumanRegistry>> watchCachedPengumuman() {
    return _isar.isarJdPengumumanRegistrys
        .where()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> cachePengumuman(List<IsarJdPengumumanRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarJdPengumumanRegistrys.clear();
      await _isar.isarJdPengumumanRegistrys.putAll(items);
    });
  }

  // -- Jenis Filters --

  @override
  Future<List<IsarJdJenisFilterRegistry>> getCachedJenisFilters() {
    return _isar.isarJdJenisFilterRegistrys.where().findAll();
  }

  @override
  Stream<List<IsarJdJenisFilterRegistry>> watchCachedJenisFilters() {
    return _isar.isarJdJenisFilterRegistrys
        .where()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> cacheJenisFilters(List<IsarJdJenisFilterRegistry> items) async {
    await _isar.writeTxn(() async {
      await _isar.isarJdJenisFilterRegistrys.clear();
      await _isar.isarJdJenisFilterRegistrys.putAll(items);
    });
  }
}
