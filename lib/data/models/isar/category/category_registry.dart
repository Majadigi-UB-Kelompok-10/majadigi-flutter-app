import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/category/category_entity.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/service/service_entity.dart';

part 'category_registry.g.dart';

@collection
class IsarCategoryRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index(type: IndexType.value)
  late String name;

  late String description;

  late DateTime createdAt;

  @Backlink(to: 'categories')
  final services = IsarLinks<IsarServiceRegistry>();

  @ignore
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      services: services.map(
        (service) => ServiceEntity(
          id: service.id,
          title: service.title,
          description: service.description,
          iconUrl: service.iconUrl,
          createdAt: service.createdAt
        )).toList(),
      createdAt: createdAt
    );
  }
}