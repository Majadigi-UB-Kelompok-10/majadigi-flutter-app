import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/generic_supabase_service.dart';
import 'package:majadigi_mobile/data/model/supabase/service_list_model.dart';

// * Providers
// ? Supabase Data Fetch Provider for Services List
final serviceListProvider = AsyncNotifierProvider.autoDispose<
    ServiceListNotifier,
    List<ServiceListModel>
>(ServiceListNotifier.new);

// * Notifiers
// ? Supabase Data Fetch Notifier for Services List
class ServiceListNotifier extends SupabaseFetchNotifier<ServiceListModel, ServiceListColumn> {
  ServiceListNotifier();

  @override
  SupabaseFetchArgs<ServiceListColumn> get arguments => SupabaseFetchArgs(
    columns: [
      ServiceListColumn.service_list_id,
      ServiceListColumn.title,
      ServiceListColumn.description,
      ServiceListColumn.icon_url
    ],
    filters: null,
    isSingle: false,
  );

  @override
  ServiceListModel fromJson(Map<String, dynamic> json) => ServiceListModel.fromJson(json);

  @override
  String get tableName => "service_list";
}