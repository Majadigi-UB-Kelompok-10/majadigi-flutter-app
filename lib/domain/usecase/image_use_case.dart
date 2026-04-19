import 'package:majadigi_mobile_rebuild/domain/repositories/image_repository.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/image/image_entity.dart';

/// Get all images in service
/// @return ImageEntity
class GetAllImagesForServiceUseCase {
  final ImageRepository repository;
  GetAllImagesForServiceUseCase(this.repository);

  Future<List<ImageEntity>> execute(String serviceId) async {
    return await repository.getAllImagesForService(serviceId);
  }
}

/// Watch all images in service
/// @return Stream<List<ImageEntity>>
class WatchAllImagesForServiceUseCase {
  final ImageRepository repository;
  WatchAllImagesForServiceUseCase(this.repository);

  Stream<List<ImageEntity>> execute(String serviceId) {
    return repository.watchAllImagesForService(serviceId);
  }
}

/// Sync image from remote datasource
/// @return void
class SyncImagesUseCase {
  final ImageRepository repository;
  SyncImagesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncImages();
  }
}