import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/category/category_registry.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';

part 'service_registry.g.dart';

/// Service Registry for Isar
/// Connected with Category (SQL to NoSQL)
@collection
class IsarServiceRegistry {
  Id get isarId => fastHash(id);

  @Index(type: IndexType.value, unique: true)
  late String id;

  late String title;

  late String description;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords => Isar.splitWords('$title $description');

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get revContentWords {
    return contentWords
        .map((word) => word.split('')
        .reversed
        .join(''))
        .toList();
  }

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
      categories: categories
          .map(
            (cat) => CategoryEntity(
              id: cat.id,
              name: cat.name,
              description: cat.description,
              createdAt: cat.createdAt,
            ),
          )
          .toList(),
      createdAt: createdAt,
    );
  }
}
