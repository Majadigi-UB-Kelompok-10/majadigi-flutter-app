import 'package:majadigi_mobile_rebuild/domain/entities/image/image_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/repositories/image_repository.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/image/image_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/data/datasources/image/image_remote_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageLocalDatasource localDatasource;
  final ImageRemoteDatasource remoteDatasource;

  ImageRepositoryImpl(
    {
      required this.localDatasource,
      required this.remoteDatasource
    }
  );

  @override
  Future<List<ImageEntity>> getAllImagesForService(String serviceId) {
    return localDatasource.getCachedImageForService(serviceId).then((image) {
      return image.map((image) => image.toEntity()).toList();
    });
  }

  @override
  Future<void> syncImages() async {
    try {
      final images = await remoteDatasource.fetchImageFromNetwork();

      final imageIsar = images.map((image) => image.toIsar()).toList();

      localDatasource.cacheImage(imageIsar);
    } catch (e) { /* None */ }
  }

  @override
  Stream<List<ImageEntity>> watchAllImagesForService(String serviceId) {
    return localDatasource.watchCachedImageForService(serviceId).map((image) {
      return image.map((image) => image.toEntity()).toList();
    });
  }
}