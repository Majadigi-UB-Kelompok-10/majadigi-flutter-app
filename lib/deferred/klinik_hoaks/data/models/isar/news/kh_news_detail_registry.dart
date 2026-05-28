import 'package:isar_community/isar.dart';
import '../../../../domain/entities/news/kh_news_detail_entity.dart';

part 'kh_news_detail_registry.g.dart';

@collection
class IsarKhNewsDetailRegistry {
  Id id = Isar.autoIncrement;

  late String newsId;

  String? title;

  @Index(unique: true, replace: true)
  late String slug;

  String? description;

  String? referenceLink;

  String? imageUrl;

  String? categoryName;

  String? categorySlug;

  String? publishedAt;

  @ignore
  KhNewsDetailEntity toEntity() {
    return KhNewsDetailEntity(
      id: newsId,
      title: title,
      slug: slug,
      description: description,
      referenceLink: referenceLink,
      imageUrl: imageUrl,
      categoryName: categoryName,
      categorySlug: categorySlug,
      publishedAt: publishedAt,
    );
  }
}
