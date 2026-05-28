import 'package:isar_community/isar.dart';
import '../models/isar/bansos/bansos_registry.dart';
import '../../../../main/data/models/isar/fast_hash.dart';

abstract class BansosLocalDatasource {
  Future<IsarBansosRegistry?> getCachedBansosByNik(String nik);
  Stream<List<IsarBansosRegistry>> watchCachedBansosByNik(String nik);
  Future<void> cacheBansos(IsarBansosRegistry bansos);
}

class BansosLocalDatasourceImpl implements BansosLocalDatasource {
  final Isar _isar;
  BansosLocalDatasourceImpl(this._isar);

  @override
  Future<IsarBansosRegistry?> getCachedBansosByNik(String nik) {
    final id = fastHash(nik);
    return _isar.isarBansosRegistrys.get(id);
  }

  @override
  Future<void> cacheBansos(IsarBansosRegistry bansos) async {
    await _isar.writeTxn(() async {
      await _isar.isarBansosRegistrys.putByNik(bansos);
    });
  }

  @override
  Stream<List<IsarBansosRegistry>> watchCachedBansosByNik(String nik) {
    final id = fastHash(nik);

    return _isar.isarBansosRegistrys.where().idEqualTo(id).watch(fireImmediately: true);
  }
}
