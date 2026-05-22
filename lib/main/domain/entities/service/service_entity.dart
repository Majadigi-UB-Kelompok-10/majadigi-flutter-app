import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';

part 'service_entity.freezed.dart';

/// Represent a Service Entity
@freezed
class ServiceEntity with _$ServiceEntity {
  const ServiceEntity({
    this.id,
    this.title,
    this.longTitle,
    this.description,
    this.iconUrl,
    this.categories,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? longTitle;

  @override
  final String? title;

  @override
  final String? description;

  @override
  final String? iconUrl;

  @override
  final List<CategoryEntity>? categories;

  @override
  final DateTime? createdAt;
}