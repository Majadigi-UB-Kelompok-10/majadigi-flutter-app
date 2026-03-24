import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/generic_supabase_service.dart';
import 'package:majadigi_mobile/data/model/supabase/image_list_model.dart';

// ? Supabase Data Fetch Provider for Images List
final imageListProvider = AsyncNotifierProvider.autoDispose.family<
    ImageListNotifier,
    List<ImageListModel>,
    String
>(ImageListNotifier.new);

// ? Supabase Data Fetch Notifier for Images List
class ImageListNotifier extends SupabaseFetchNotifier<ImageListModel, ImageListColumn> {
  ImageListNotifier(this.serviceListId);

  final String serviceListId;

  @override
  SupabaseFetchArgs<ImageListColumn> get arguments => SupabaseFetchArgs(
    columns: [
      ImageListColumn.image_list_id,
      ImageListColumn.service_list_id,
      ImageListColumn.image_url,
      ImageListColumn.semantic_label,
    ],
    filters: {
      ImageListColumn.service_list_id: serviceListId,
    },
    isSingle: false,
  );

  @override
  ImageListModel fromJson(Map<String, dynamic> json) => ImageListModel.fromJson(json);

  @override
  String get tableName => "image_list";
}