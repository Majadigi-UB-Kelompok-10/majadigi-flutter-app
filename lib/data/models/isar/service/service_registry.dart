import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/category/category_entity.dart';

part 'service_registry.g.dart';

/// Service Registry for Isar
/// Connected with Category (SQL to NoSQL)
@collection
class IsarServiceRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index(type: IndexType.value)
  late String title;

  @Index(type: IndexType.value)
  late String description;

  late String iconUrl;

  late DateTime createdAt;

  final categories = IsarLinks<IsarCategoryRegistry>();

  @ignore
  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      title: title,
      description: description,
      iconUrl: iconUrl,
      categories: categories.map(
        (cat) => CategoryEntity(
          id: cat.id,
          name: cat.name,
          description: cat.description,
          createdAt: cat.createdAt
        )
      ).toList(),
      createdAt: createdAt
    );
  }
}