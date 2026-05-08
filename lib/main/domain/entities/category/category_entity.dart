import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

part 'category_entity.freezed.dart';

/// Represent a Category Entity
@freezed
class CategoryEntity with _$CategoryEntity {
  const CategoryEntity({
    this.id,
    this.name,
    this.description,
    this.services,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? name;

  @override
  final String? description;

  @override
  final List<ServiceEntity>? services;

  @override
  final DateTime? createdAt;
}