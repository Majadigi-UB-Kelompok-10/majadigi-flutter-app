import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/generic_supabase_service.dart';
import 'package:majadigi_mobile/data/model/supabase/operational_list_model.dart';

// ? Supabase Data Fetch Provider for Operational List
final operationalListProvider = AsyncNotifierProvider.autoDispose.family<
    OperationalListNotifier,
    List<OperationalListModel>,
    String
>(OperationalListNotifier.new);

// ? Supabase Data Fetch Notifier for Operational List
class OperationalListNotifier extends SupabaseFetchNotifier<OperationalListModel, OperationalListColumn> {
  OperationalListNotifier(this.serviceListId);

  final String serviceListId;

  @override
  SupabaseFetchArgs<OperationalListColumn> get arguments => SupabaseFetchArgs(
    columns: [
      OperationalListColumn.operational_list_id,
      OperationalListColumn.service_list_id,
      OperationalListColumn.service_url,
      OperationalListColumn.address,
      OperationalListColumn.operational_hour,
      OperationalListColumn.social_media,
    ],
    filters: {
      OperationalListColumn.service_list_id: serviceListId,
    },
    isSingle: false,
  );

  @override
  OperationalListModel fromJson(Map<String, dynamic> json) => OperationalListModel.fromJson(json);

  @override
  String get tableName => "operational_list";
}