// ? Enums representing columns
enum PolicyListColumn {
  policy_list_id,
  service_list_id,
  benefit,
  instruction,
  created_at
}

// ? Main Image List Table
class PolicyListModel {
  final String? id;
  final String? fkServiceListId;
  final Map<String, dynamic>? benefit;
  final Map<String, dynamic>? instruction;
  final DateTime? createdAt;

  // Constructor
  PolicyListModel({
    this.id,
    this.fkServiceListId,
    this.benefit,
    this.instruction,
    this.createdAt,
  });

  // Factory (JSON Parse)
  factory PolicyListModel.fromJson(Map<String, dynamic> json) {
    return PolicyListModel(
      id: json[PolicyListColumn.policy_list_id.name] as String?,
      fkServiceListId: json[PolicyListColumn.service_list_id.name] as String?,
      benefit: json[PolicyListColumn.benefit.name] as Map<String, dynamic>?,
      instruction: json[PolicyListColumn.instruction.name] as Map<String, dynamic>?,
      createdAt: json[PolicyListColumn.created_at.name] as DateTime?,
    );
  }
}