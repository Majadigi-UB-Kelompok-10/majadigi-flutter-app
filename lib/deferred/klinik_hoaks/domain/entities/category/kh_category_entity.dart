import 'package:freezed_annotation/freezed_annotation.dart';

part 'kh_category_entity.freezed.dart';

@freezed
class KhCategoryEntity with _$KhCategoryEntity {
  const KhCategoryEntity({
    this.id,
    this.name,
    this.slug,
    this.iconUrl,
  });

  @override
  final String? id;

  @override
  final String? name;

  @override
  final String? slug;

  @override
  final String? iconUrl;
}
