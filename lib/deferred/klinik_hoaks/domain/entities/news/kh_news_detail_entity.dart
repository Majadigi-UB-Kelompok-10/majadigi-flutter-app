import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_news_detail_entity.freezed.dart';

@freezed
class KhNewsDetailEntity with _$KhNewsDetailEntity {
  const KhNewsDetailEntity({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.referenceLink,
    this.imageUrl,
    this.categoryName,
    this.categorySlug,
    this.publishedAt,
  });

  @override
  final String? id;

  @override
  final String? title;

  @override
  final String? slug;

  @override
  final String? description;

  @override
  final String? referenceLink;

  @override
  final String? imageUrl;

  @override
  final String? categoryName;

  @override
  final String? categorySlug;

  @override
  final String? publishedAt;
}
