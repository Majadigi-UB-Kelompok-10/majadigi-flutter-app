import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_entity.freezed.dart';

/// Represent Endpoint Entity
@freezed
class EndpointEntity with _$EndpointEntity {
  const EndpointEntity({
    this.id,
    this.slugName,
    this.pageUrl,
    this.createdAt
  });

  @override
  final String? id;

  @override
  final String? slugName;

  @override
  final String? pageUrl;

  @override
  final DateTime? createdAt;
}