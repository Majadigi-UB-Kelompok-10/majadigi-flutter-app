
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ? Example
// https://nhsdrdhzkogczngslvvh.supabase.co/storage/v1/object/public/data-assets/pages/file_list.json

final String baseURL = 'https://nhsdrdhzkogczngslvvh.supabase.co/storage/v1/object/public/';
final String dataURL = 'data-assets/pages/';
final String imageURL = 'image-asset/';

// Local for now
final String extBaseURL = 'http://10.0.2.2:8080/api/v1/';

// ! Cache Store for Dio
final dioCacheStoreProvider = FutureProvider.autoDispose<FileCacheStore>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return FileCacheStore(dir.path);
});

final dioProvider = FutureProvider.autoDispose<Dio>((ref) async {
  final store = await ref.watch(dioCacheStoreProvider.future);

  // Configure the caching rules
  final cacheOptions = CacheOptions(
    store: store,
    policy: CachePolicy.request,
    hitCacheOnNetworkFailure: true,
    maxStale: const Duration(days: 365),
    priority: CachePriority.normal,
  );

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  // Add Cache interceptor to Dio
  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

  return dio;
});