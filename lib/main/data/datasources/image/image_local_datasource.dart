import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/image/image_registry.dart';

/// Represent the Contract for Image Local Datasource.
/// Uses Isar Database.
abstract class ImageLocalDatasource {
  Stream<List<IsarImageRegistry>> watchCachedImage();
  Stream<List<IsarImageRegistry>> watchCachedImageForService(String serviceId);
  Future<List<IsarImageRegistry>> getCachedImage();
  Future<List<IsarImageRegistry>> getCachedImageForService(String serviceId);
  Future<void> cacheImage(List<IsarImageRegistry> image);
}

/// Represent the Image Local Datasource Implementation
class ImageLocalDatasourceImpl implements ImageLocalDatasource {
  final Isar _isar;
  ImageLocalDatasourceImpl(this._isar);

  @override
  Future<void> cacheImage(List<IsarImageRegistry> image) async {
    await _isar.writeTxn(() async {
      await _isar.isarImageRegistrys.putAllById(image);
    });
  }

  @override
  Stream<List<IsarImageRegistry>> watchCachedImage() {
    return _isar.isarImageRegistrys.where().watch(fireImmediately: true);
  }

  @override
  Stream<List<IsarImageRegistry>> watchCachedImageForService(String serviceId) {
    return _isar.isarImageRegistrys
        .filter()
        .fkServiceListIdEqualTo(serviceId)
        .watch(fireImmediately: true);
  }

  @override
  Future<List<IsarImageRegistry>> getCachedImage() {
    return _isar.isarImageRegistrys.where().findAll();
  }

  @override
  Future<List<IsarImageRegistry>> getCachedImageForService(String serviceId) {
    return _isar.isarImageRegistrys
        .filter()
        .fkServiceListIdEqualTo(serviceId)
        .findAll();
  }
}
