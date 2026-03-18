import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/data/model/services_list_model.dart';
import 'package:majadigi_mobile/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:majadigi_mobile/cache.dart';

// * Fetch Services available from Supabase Database
// * Cached manually
// ! Strictly uses JSON array (Supabase Default, Starts with "[")
// ! But delegated to service list model
final servicesFutureProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final cacheStore = await ref.read(cacheStoreProvider.future);
  const cacheKey = 'majadigi_services_list';

  try {
    final response = await Supabase
        .instance
        .client
        .from('services_list')
        .select('id, icon, title, description');

    await cacheStore.save(key: cacheKey, value: jsonEncode(response));

    return response.map((json) => ServiceModel.fromJson(json)).toList();
  } catch (e) {
    final cachedData = await cacheStore.read(key: cacheKey);

    if (cachedData != null) {
      final List<dynamic> decodedList = jsonDecode(cachedData);

      return decodedList
          .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('No internet and no cached data available.');
  }
});

// * Fetch JSONB Page Data from Supabase Database
// * Cached manually
final jsonbFutureProvider = FutureProvider.family<AdditionalData, String>((ref, id) async {
  final cacheStore = await ref.read(cacheStoreProvider.future);
  final cacheKey = 'majadigi_services_detail_$id';

  try {
    final response = await Supabase
        .instance
        .client
        .from('services_list')
        .select('additional_data')
        .eq('id', id)
        .single();

    final Map<String, dynamic> rawJsonb = response['additional_data'] as Map<String, dynamic>;

    await cacheStore.save(key: cacheKey, value: jsonEncode(rawJsonb));

    return AdditionalData.fromJson(rawJsonb);
  } catch (e) {
    final cachedData = await cacheStore.read(key: cacheKey);

    if (cachedData != null) {
      final Map<String, dynamic> decoded = jsonDecode(cachedData);
      return AdditionalData.fromJson(decoded);
    }

    throw Exception('No internet and no cached data available.');
  }
});

// * Fetch assets based on Argument from Supabase Storage
// * Cached by Dio
// ! Strictly uses JSON objects (Starts with "{")
final pageLayoutFutureProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, pageLayout) async {
  final dio = await ref.watch(dioProvider.future);

  try {
    final response = await dio.get(
      '$dataURL$pageLayout',
      options: Options(extra: {'fallback': pageLayout})
    );

    dynamic rawData = response.data;
    if (rawData is String) {
      rawData = jsonDecode(rawData);
    }

    return rawData as Map<String, dynamic>;

  } on DioException catch (e) {
    throw Exception('Dio Error [${e.response?.statusCode}]: Failed to load $pageLayout');
  } on Exception catch (e) {
    throw Exception('Failed to load $pageLayout: $e');
  }
});