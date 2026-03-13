import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final String baseURL = "http://10.0.2.2:8080/";
final String baseURL = 'https://raw.githubusercontent.com/Majadigi-UB-Kelompok-10/majadigi-static-file/';
final String docsURL = 'api/cdn/download/docs/';
final String imageURL = 'api/cdn/download/images/';

// final dio = Dio(
//   BaseOptions(
//     baseUrl: baseURL,
//     connectTimeout: const Duration(seconds: 3),
//   ),
// )..interceptors.add(LogInterceptor(
//   requestBody: true,
//   responseBody: true,
//   requestHeader: false,
// ));

// Cache Store
final cacheStoreProvider = FutureProvider<FileCacheStore>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return FileCacheStore(dir.path);
});

final dioProvider = FutureProvider<Dio>((ref) async {
  final store = await ref.watch(cacheStoreProvider.future);

  // Configure the caching rules
  final cacheOptions = CacheOptions(
    store: store,
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 365),
    priority: CachePriority.normal,
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  // Add the interceptor to Dio
  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: false,
  ));

  return dio;
});

// https://raw.githubusercontent.com/Majadigi-UB-Kelompok-10/majadigi-static-file/refs/heads/main/file_list.json