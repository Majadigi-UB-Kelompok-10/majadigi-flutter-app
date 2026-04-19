import 'package:majadigi_mobile_rebuild/domain/repositories/image_repository.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/image/image_entity.dart';

/// Get all images in serviceId
/// @return ImageEntity
class GetAllImagesForServiceUseCase {
  final ImageRepository repository;
  GetAllImagesForServiceUseCase(this.repository);

  Future<List<ImageEntity>> execute(String serviceId) async {
    return await repository.getAllImagesForService(serviceId);
  }
}