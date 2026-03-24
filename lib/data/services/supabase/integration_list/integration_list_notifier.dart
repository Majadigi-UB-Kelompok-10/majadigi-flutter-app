import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/generic_supabase_service.dart';
import 'package:majadigi_mobile/data/model/supabase/integration_list_model.dart';

// ? Supabase Data Fetch Provider for Integration List
final integrationListProvider = AsyncNotifierProvider.autoDispose.family<
    IntegrationListNotifier,
    List<IntegrationListModel>,
    String
>(IntegrationListNotifier.new);

// ? Supabase Data Fetch Notifier for Integration List
class IntegrationListNotifier extends SupabaseFetchNotifier<IntegrationListModel, IntegrationListColumn> {
  IntegrationListNotifier(this.serviceListId);

  final String serviceListId;

  @override
  SupabaseFetchArgs<IntegrationListColumn> get arguments => SupabaseFetchArgs(
    columns: [
      IntegrationListColumn.integration_list_id,
      IntegrationListColumn.service_list_id,
      IntegrationListColumn.title,
      IntegrationListColumn.page_url,
      IntegrationListColumn.data_url,
      IntegrationListColumn.icon_url,
    ],
    filters: {
      IntegrationListColumn.service_list_id: serviceListId,
    },
    isSingle: false,
  );

  @override
  IntegrationListModel fromJson(Map<String, dynamic> json) => IntegrationListModel.fromJson(json);

  @override
  String get tableName => "integration_list";
}