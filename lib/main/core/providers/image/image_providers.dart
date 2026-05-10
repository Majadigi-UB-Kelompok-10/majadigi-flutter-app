import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/image/image_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/image/image_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/image_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/image/image_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/image_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/usecase/image_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_providers.g.dart';

/// Local Datasource for Image
@riverpod
ImageLocalDatasource _imageLocalDatasource(Ref ref) {
  return ImageLocalDatasourceImpl(ref.watch(isarProvider));
}

/// Remote Datasource for Image
@riverpod
ImageRemoteDatasource _imageRemoteDatasource(Ref ref) {
  return ImageRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
  );
}

/// Repository for Image
@riverpod
ImageRepository _imageRepository(Ref ref) {
  return ImageRepositoryImpl(
    localDatasource: ref.watch(_imageLocalDatasourceProvider),
    remoteDatasource: ref.watch(_imageRemoteDatasourceProvider),
  );
}

// -- Implement Use Cases for Image --
/// Watch all images from Isar Database
@riverpod
WatchAllImagesForServiceUseCase _watchAllImageForServiceUseCase(Ref ref) {
  return WatchAllImagesForServiceUseCase(ref.watch(_imageRepositoryProvider));
}

/// Sync images from Remote Data Sources
@riverpod
SyncImagesUseCase syncImageUseCase(Ref ref) {
  return SyncImagesUseCase(ref.watch(_imageRepositoryProvider));
}

/// Get all images in a specific service as a List\<ImageEntity\>
@riverpod
GetAllImagesForServiceUseCase _getAllImageForServiceUseCase(Ref ref) {
  return GetAllImagesForServiceUseCase(
    ref.watch(_imageRepositoryProvider),
  );
}

// -- Exposed Use Case for Image --
/// Sync Image from Remote Datasource while Providing Stale Data
@riverpod
Stream<List<ImageEntity>> imageList(Ref ref, String serviceId) {
  final watchAllImageUseCase = ref.watch(_watchAllImageForServiceUseCaseProvider);

  // Watch from database
  return watchAllImageUseCase.execute(serviceId);
}

/// Get all images in a specific service as a List<ImageEntity> (Passthrough)
@riverpod
Future<List<ImageEntity>> getAllImageForService(Ref ref, String serviceId) async {
  final getAllImageForServiceUseCase = ref.watch(
    _getAllImageForServiceUseCaseProvider,
  );

  return await getAllImageForServiceUseCase.execute(serviceId);
}
