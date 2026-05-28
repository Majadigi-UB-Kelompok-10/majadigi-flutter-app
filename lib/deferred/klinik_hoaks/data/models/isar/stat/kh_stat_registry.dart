import 'package:isar_community/isar.dart';
import '../../../../domain/entities/stat/kh_stat_entity.dart';

part 'kh_stat_registry.g.dart';

@collection
class IsarKhStatRegistry {
  Id id = Isar.autoIncrement;

  late String categoryId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String categoryName;

  late String categorySlug;

  String? iconUrl;

  late int totalNews;

  @ignore
  KhStatEntity toEntity() {
    return KhStatEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      categorySlug: categorySlug,
      iconUrl: iconUrl,
      totalNews: totalNews,
    );
  }
}
