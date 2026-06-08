import 'package:isar_community/isar.dart';

part 'prefer_category_registry.g.dart';

@collection
class IsarPreferCategoryRegistry {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String id = "preferred_categories";

  late List<String> categoryIds;
}
