import 'package:isar_community/isar.dart';
import '../models/isar/blk/snk_blk_registry.dart';

abstract class SnkLocalDatasource {
  Stream<List<IsarSnkBlkRegistry>> watchBlkList();
  Future<void> saveBlkList(List<IsarSnkBlkRegistry> items);
}

class SnkLocalDatasourceImpl implements SnkLocalDatasource {
  final Isar isar;
  SnkLocalDatasourceImpl(this.isar);

  @override
  Stream<List<IsarSnkBlkRegistry>> watchBlkList() {
    return isar.isarSnkBlkRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<void> saveBlkList(List<IsarSnkBlkRegistry> items) async {
    await isar.writeTxn(() async {
      await isar.isarSnkBlkRegistrys.clear();
      await isar.isarSnkBlkRegistrys.putAllByBlkId(items);
    });
  }
}
