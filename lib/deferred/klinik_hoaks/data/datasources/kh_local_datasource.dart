import 'package:isar_community/isar.dart';
import '../models/isar/stat/kh_stat_registry.dart';
import '../models/isar/news/kh_news_registry.dart';
import '../models/isar/news/kh_news_detail_registry.dart';

abstract class KhLocalDatasource {
  // Stats
  Stream<List<IsarKhStatRegistry>> watchStats();
  Future<void> saveStats(List<IsarKhStatRegistry> items);

  // News
  Stream<List<IsarKhNewsRegistry>> watchNews();
  Future<void> saveNews(List<IsarKhNewsRegistry> items);
  Stream<List<IsarKhNewsRegistry>> searchNews(String query);

  // News Detail
  Future<IsarKhNewsDetailRegistry?> getNewsDetailBySlug(String slug);
  Future<void> saveNewsDetail(IsarKhNewsDetailRegistry detail);
}

class KhLocalDatasourceImpl implements KhLocalDatasource {
  final Isar isar;
  KhLocalDatasourceImpl(this.isar);

  // -- Stats --

  @override
  Stream<List<IsarKhStatRegistry>> watchStats() {
    return isar.isarKhStatRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<void> saveStats(List<IsarKhStatRegistry> items) async {
    await isar.writeTxn(() async {
      await isar.isarKhStatRegistrys.clear();
      await isar.isarKhStatRegistrys.putAll(items);
    });
  }

  // -- News --

  @override
  Stream<List<IsarKhNewsRegistry>> watchNews() {
    return isar.isarKhNewsRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<void> saveNews(List<IsarKhNewsRegistry> items) async {
    await isar.writeTxn(() async {
      await isar.isarKhNewsRegistrys.clear();
      await isar.isarKhNewsRegistrys.putAll(items);
    });
  }

  @override
  Stream<List<IsarKhNewsRegistry>> searchNews(String query) {
    return isar.isarKhNewsRegistrys
        .filter()
        .titleContains(query, caseSensitive: false)
        .watch(fireImmediately: true);
  }

  // -- News Detail --

  @override
  Future<IsarKhNewsDetailRegistry?> getNewsDetailBySlug(String slug) {
    return isar.isarKhNewsDetailRegistrys
        .filter()
        .slugEqualTo(slug)
        .findFirst();
  }

  @override
  Future<void> saveNewsDetail(IsarKhNewsDetailRegistry detail) async {
    await isar.writeTxn(() async {
      await isar.isarKhNewsDetailRegistrys.putBySlug(detail);
    });
  }
}
