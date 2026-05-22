import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_entity.freezed.dart';

/// Represent Policy Entity
@freezed
class PolicyEntity with _$PolicyEntity {
  const PolicyEntity({
    this.id,
    this.fkServiceListId,
    this.benefit,
    this.instruction,
    this.createdAt,
  });

  @override
  final String? id;

  @override
  final String? fkServiceListId;

  @override
  final dynamic benefit;

  @override
  final dynamic instruction;

  @override
  final DateTime? createdAt;
}