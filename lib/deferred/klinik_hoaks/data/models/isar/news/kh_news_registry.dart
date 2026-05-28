import 'package:isar_community/isar.dart';
import '../../../../domain/entities/news/kh_news_entity.dart';

part 'kh_news_registry.g.dart';

@collection
class IsarKhNewsRegistry {
  Id id = Isar.autoIncrement;

  late String newsId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String title;

  @Index(unique: true, replace: true)
  late String slug;

  String? imageUrl;

  String? categoryName;

  String? categorySlug;

  String? publishedAt;

  @ignore
  KhNewsEntity toEntity() {
    return KhNewsEntity(
      id: newsId,
      title: title,
      slug: slug,
      imageUrl: imageUrl,
      categoryName: categoryName,
      categorySlug: categorySlug,
      publishedAt: publishedAt,
    );
  }
}
