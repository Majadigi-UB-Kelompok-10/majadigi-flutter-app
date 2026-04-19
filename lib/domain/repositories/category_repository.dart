import 'package:majadigi_mobile_rebuild/domain/entities/category/category_entity.dart';

/// Represent Contracts for Categories
abstract class CategoryRepository {
  // SWR Specific Implementation
  Stream<List<CategoryEntity>> watchAllCategory();
  Future<void> syncCategory();

  // General Use Cases
  Future<List<CategoryEntity>> getAllCategoryForService(String serviceId);
}