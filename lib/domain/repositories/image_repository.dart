import 'package:majadigi_mobile_rebuild/domain/entities/image/image_entity.dart';

/// Represent Contract for Images
abstract class ImageRepository {
  // SWR Specific Implementation
  Stream<List<ImageEntity>> watchAllImagesForService(String serviceId);
  Future<void> syncImages();

  // General Use Case
  Future<List<ImageEntity>> getAllImagesForService(String serviceId);
}