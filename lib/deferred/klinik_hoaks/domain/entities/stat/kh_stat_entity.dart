import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_stat_entity.freezed.dart';

@freezed
class KhStatEntity with _$KhStatEntity {
  const KhStatEntity({
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.iconUrl,
    this.totalNews,
  });

  @override
  final String? categoryId;

  @override
  final String? categoryName;

  @override
  final String? categorySlug;

  @override
  final String? iconUrl;

  @override
  final int? totalNews;
}
