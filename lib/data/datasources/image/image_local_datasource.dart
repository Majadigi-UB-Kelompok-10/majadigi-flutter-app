import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/image/image_registry.dart';

/// Represent the Contract for Image Local Datasource.
/// Uses Isar Database.
abstract class ImageLocalDatasource {
  Stream<List<IsarImageRegistry>> watchCachedImage();
  Future<List<IsarImageRegistry>> getCachedImage();
  Future<void> cacheImage(List<IsarImageRegistry> image);
}

/// Represent the Image Local Datasource Implementation
class ImageLocalDatasourceImpl implements ImageLocalDatasource {
  final Isar _isar;
  ImageLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheImage(List<IsarImageRegistry> image) async {
    await _isar.writeTxn(() async {
      await _isar.isarImageRegistrys.putAll(image);
    });
  }

  @override
  Stream<List<IsarImageRegistry>> watchCachedImage() {
    return _isar.isarImageRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Future<List<IsarImageRegistry>> getCachedImage() {
    return _isar.isarImageRegistrys.where().findAll();
  }
}