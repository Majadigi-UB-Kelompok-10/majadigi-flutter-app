import 'package:freezed_annotation/freezed_annotation.dart';

part 'integration_entity.freezed.dart';

/// Represent Integration Entity
@freezed
class IntegrationEntity with _$IntegrationEntity {
  const IntegrationEntity({
    this.id,
    this.fkServiceListId,
    this.fkEndpointListId,
    this.title,
    this.iconUrl,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? fkServiceListId;

  @override
  final String? fkEndpointListId;

  @override
  final String? title;

  @override
  final String? iconUrl;

  @override
  final DateTime? createdAt;

}