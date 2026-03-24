import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// * Generic Base Notifiers
// ? Generic Argument using Equatable to fix UI rendering issue
class SupabaseFetchArgs<E extends Enum> extends Equatable {
  final List<E> columns;
  final Map<E, String>? filters;
  final bool? isSingle;

  const SupabaseFetchArgs({
    required this.columns,
    this.filters,
    this.isSingle,
  });

  // Stop infinite loops by putting props with help of Equatable package
  @override
  List<Object?> get props => [columns, filters, isSingle];
}

// ? Generic Supabase Data Fetch Abstract Class
// T = Model, E = Enum
abstract class SupabaseFetchNotifier<T, E extends Enum> extends AsyncNotifier<List<T>> {
  String get tableName;
  T fromJson(Map<String, dynamic> json);

  @protected
  SupabaseFetchArgs<E> get arguments;

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
    if (arguments.columns.isEmpty) {
      throw ArgumentError('You must select at least one column.');
    }

    // Construct CacheStore
    final cacheStore = await ref.read(cacheStoreProvider.future);
    String cacheKey = 'majadigi_resource_$tableName';

    // Map enums using .name property
    final selectString = arguments.columns.map((c) => c.name).join(', ');

    // Build supabase query
    var query = Supabase.instance.client.from(tableName).select(selectString);

    // Check against filters
    if (arguments.filters != null && arguments.filters!.isNotEmpty) {
      for (final entry in arguments.filters!.entries) {
        query = query.eq(entry.key.name, entry.value);
        cacheKey = '${cacheKey}_${entry.key.name}_${entry.value}';
      }

      // Check against isSingle
      if (arguments.isSingle != null && arguments.isSingle!) {
        cacheKey = '${cacheKey}_single';

        // * SWR
        await _fetchCache(cacheKey: cacheKey, isSingle: arguments.isSingle!);

        try {
          final response = await query.maybeSingle();

          if (response == null) return [];

          await cacheStore.save(key: cacheKey, value: jsonEncode(response));

          return [fromJson(response)];
        } catch (e) {
          return state.value ?? [];
        }
      }
    }

    // * SWR
    await _fetchCache(cacheKey: cacheKey, isSingle: false);

    // If no filter or check, then base query fetch & cache
    try {
      final response = await query;
      await cacheStore.save(key: cacheKey, value: jsonEncode(response));
      return response.map((json) => fromJson(json)).toList();
    } catch (e) {
      return state.value ?? [];
    }
  }
}