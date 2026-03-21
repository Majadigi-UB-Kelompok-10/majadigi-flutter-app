import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/data/model/supabase_table_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majadigi_mobile/cache.dart';

/*
 * Services implemented here is related to SDUI
 * with caching strategy known as "Stale-While-Revalidate"
 * or SWR through manual implementation in client level
 * to ensure that it will cache regardless of caching
 * policy in place. Not only that, we're migrating
 * to Riverpod 3.x so an overhaul is much needed
 *
 * ! It is not advisable to use caching strategy in !
 * ! sensitive operations or pages that uses auth   !
 */

// * Providers
// ? Supabase Data Fetch Provider for Services List
final articleProvider = AsyncNotifierProvider.autoDispose.family<
    ServiceListNotifier,
    List<ServiceListModel>,
    SupabaseFetchArgs<ServiceListColumn>
>(ServiceListNotifier.new);

// * Notifiers
// ? Supabase Data Fetch Notifier for Services List
class ServiceListNotifier extends SupabaseFetchNotifier<ServiceListModel, ServiceListColumn> {
  ServiceListNotifier(this._arguments);

  @override
  final SupabaseFetchArgs<ServiceListColumn> _arguments;

  @override
  ServiceListModel fromJson(Map<String, dynamic> json) => ServiceListModel.fromJson(json);

  @override
  String get tableName => "services_list";

  @override
  Future<List<ServiceListModel>> build() {
    // * SWR Caching Strategy for Service List
    return super.build();
  }
}

// * Generic Base Notifiers
// ? Generic Argument Typedef
typedef SupabaseFetchArgs<E extends Enum> = ({List<E> columns, String? id, bool? isSingle});

// ? Generic Supabase Data Fetch Abstract Class
// T = Model, E = Enum
abstract class SupabaseFetchNotifier<T, E extends Enum> extends AsyncNotifier<List<T>> {
  String get tableName;
  T fromJson(Map<String, dynamic> json);
  SupabaseFetchArgs<E> get _arguments;

  // * Helper for Cache Fetch (SWR)
  Future<void> _fetchCache({
    required String cacheKey,
    required bool isSingle,
  }) async {
    final cacheStore = await ref.read(cacheStoreProvider.future);

    final cachedString = await cacheStore.read(key: cacheKey);
    if (cachedString != null) {
      try {
        if (isSingle) {
          final decodedMap = jsonDecode(cachedString) as Map<String, dynamic>;
          state = AsyncValue.data([fromJson(decodedMap)]);
        } else {
          final decodedList = jsonDecode(cachedString) as List<dynamic>;
          state = AsyncValue.data(
              decodedList.map((item) => fromJson(item as Map<String, dynamic>)).toList()
          );
        }
      } catch (e) {
        // For debugging purposes..
        // print('Failed to parse cache for $tableName: $e');
      }
    }
  }

  @override
  Future<List<T>> build() async {
    if (_arguments.columns.isEmpty) {
      throw ArgumentError('You must select at least one column.');
    }

    // Construct CacheStore
    final cacheStore = await ref.read(cacheStoreProvider.future);
    String cacheKey = 'majadigi_resource';

    // Map enums using .name property
    final selectString = _arguments.columns.map((c) => c.name).join(', ');

    // Build supabase query
    var query = Supabase.instance.client.from(tableName).select(selectString);

    // Check against id
    if (_arguments.id != null) {
      query = query.eq('id', _arguments.id!);
      cacheKey = '${cacheKey}_${tableName}_${_arguments.id}';

      // Check against isSingle
      if (_arguments.isSingle != null && _arguments.isSingle!) {
        cacheKey = '${cacheKey}_single';

        // * SWR
        await _fetchCache(cacheKey: cacheKey, isSingle: _arguments.isSingle!);

        final response = await query.maybeSingle();

        if (response == null) return [];

        // Save to cache first before returning response
        await cacheStore.save(key: cacheKey, value: jsonEncode(response));

        return [fromJson(response)];
      }
    }

    // * SWR
    await _fetchCache(cacheKey: cacheKey, isSingle: false);

    // If no filter or check, then base query fetch & cache
    final response = await query;
    await cacheStore.save(key: cacheKey, value: jsonEncode(response));
    return response.map((json) => fromJson(json)).toList();
  }
}