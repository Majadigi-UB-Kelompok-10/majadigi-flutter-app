import 'package:majadigi_mobile_rebuild/main/domain/repositories/category_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';

/// Get all available categories in a specific service as a List<CategoryEntity>
/// @return List<CategoryEntity>
class GetAllCategoryForServiceUseCase {
  final CategoryRepository repository;

  GetAllCategoryForServiceUseCase(this.repository);

  Future<List<CategoryEntity>> execute(String serviceId) async {
    return await repository.getAllCategoryForService(serviceId);
  }
}

/// Watch categories from Isar Database
/// @return Stream<List<CategoryEntity>>
class WatchAllCategoryUseCase {
  final CategoryRepository repository;

  WatchAllCategoryUseCase(this.repository);

  Stream<List<CategoryEntity>> execute() {
    return repository.watchAllCategory();
  }
}

/// Sync categories from Remote Data Sources
/// @return void
class SyncCategoryUseCase {
  final CategoryRepository repository;

  SyncCategoryUseCase(this.repository);

  Future<void> execute() async {
    return await repository.syncCategory();
  }
}