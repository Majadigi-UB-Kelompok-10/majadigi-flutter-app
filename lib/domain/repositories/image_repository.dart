import 'package:majadigi_mobile_rebuild/domain/entities/image/image_entity.dart';

/// Represent Contract for Images
abstract class ImageRepository {
  Future<List<ImageEntity>> getAllImagesForService(String serviceId);
}