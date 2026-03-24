import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/generic_supabase_service.dart';
import 'package:majadigi_mobile/data/model/supabase/policy_list_model.dart';

// ? Supabase Data Fetch Provider for Policy List
final policyListProvider = AsyncNotifierProvider.autoDispose.family<
    PolicyListNotifier,
    List<PolicyListModel>,
    String
>(PolicyListNotifier.new);

// ? Supabase Data Fetch Notifier for Policy List
class PolicyListNotifier extends SupabaseFetchNotifier<PolicyListModel, PolicyListColumn> {
  PolicyListNotifier(this.serviceListId);

  final String serviceListId;

  @override
  SupabaseFetchArgs<PolicyListColumn> get arguments => SupabaseFetchArgs(
    columns: [
      PolicyListColumn.policy_list_id,
      PolicyListColumn.service_list_id,
      PolicyListColumn.benefit,
      PolicyListColumn.instruction,
    ],
    filters: {
      PolicyListColumn.service_list_id: serviceListId,
    },
    isSingle: false,
  );

  @override
  PolicyListModel fromJson(Map<String, dynamic> json) => PolicyListModel.fromJson(json);

  @override
  String get tableName => "policy_list";
}