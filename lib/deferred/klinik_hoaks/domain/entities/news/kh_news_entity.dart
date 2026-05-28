import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_news_entity.freezed.dart';

@freezed
class KhNewsEntity with _$KhNewsEntity {
  const KhNewsEntity({
    this.id,
    this.title,
    this.slug,
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
  final String? imageUrl;

  @override
  final String? categoryName;

  @override
  final String? categorySlug;

  @override
  final String? publishedAt;
}
