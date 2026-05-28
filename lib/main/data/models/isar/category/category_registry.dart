import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

part 'category_registry.g.dart';

@collection
class IsarCategoryRegistry {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  late String id;

  late String name;

  late String description;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords => Isar.splitWords('$name $description');

  late DateTime createdAt;

  @Backlink(to: 'categories')
  final services = IsarLinks<IsarServiceRegistry>();

  @ignore
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      services: services
          .map(
            (service) => ServiceEntity(
              id: service.id,
              title: service.title,
              description: service.description,
              iconUrl: service.iconUrl,
              createdAt: service.createdAt,
            ),
          )
          .toList(),
      createdAt: createdAt,
    );
  }
}
