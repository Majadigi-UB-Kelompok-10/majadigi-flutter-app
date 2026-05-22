import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/policy/policy_entity.dart';

part 'policy_registry.g.dart';

@collection
class IsarPolicyRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index(unique: true)
  late String fkServiceListId;

  late String rawBenefit;

  late String rawInstruction;

  late DateTime createdAt;

  @ignore
  dynamic get jsonBenefitData {
    if (rawBenefit.isEmpty) return {};
    return jsonDecode(rawBenefit) as dynamic;
  }

  @ignore
  set jsonBenefitData(dynamic value) {
    rawBenefit = jsonEncode(value);
  }

  @ignore
  dynamic get jsonInstructionData {
    if (rawInstruction.isEmpty) return {};
    return jsonDecode(rawInstruction) as dynamic;
  }

  @ignore
  set jsonInstructionData(dynamic value) {
    rawInstruction = jsonEncode(value);
  }

  @ignore
  PolicyEntity toEntity() {
    return PolicyEntity(
      id: id,
      fkServiceListId: fkServiceListId,
      benefit: jsonBenefitData,
      instruction: jsonInstructionData,
      createdAt: createdAt
    );
  }
}