import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/policy/policy_registry.dart';

part 'policy_dto.freezed.dart';
part 'policy_dto.g.dart';

/// Model for JSON to Policy Entity Object
@freezed
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PolicyDto with _$PolicyDto {
  const PolicyDto({
    this.id,
    this.fkServiceListId,
    this.benefit,
    this.instruction,
    this.createdAt
  });

  @override
  @JsonKey(name: 'policy_list_id')
  final String? id;

  @override
  @JsonKey(name: 'service_list_id')
  final String? fkServiceListId;

  @override
  final Map<String, dynamic>? benefit;

  @override
  final Map<String, dynamic>? instruction;

  @override
  final DateTime? createdAt;

  // Json Serializable
  factory PolicyDto.fromJson(Map<String, dynamic> json) => _$PolicyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyDtoToJson(this);

  @ignore
  IsarPolicyRegistry toIsar() {
    return IsarPolicyRegistry()
      ..id = id!
      ..fkServiceListId = fkServiceListId!
      ..jsonBenefitData = benefit ?? {}
      ..jsonInstructionData = instruction ?? {}
      ..createdAt = createdAt!;
  }
}