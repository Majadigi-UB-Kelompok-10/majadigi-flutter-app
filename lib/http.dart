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

// ! Cache Store for Dio
final dioCacheStoreProvider = FutureProvider<FileCacheStore>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return FileCacheStore(dir.path);
});

final dioProvider = FutureProvider<Dio>((ref) async {
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
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  // Add Cache interceptor to Dio
  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

  return dio;
});

// https://raw.githubusercontent.com/Majadigi-UB-Kelompok-10/majadigi-static-file/refs/heads/main/file_list.json

// final String baseURLAlt = 'https://raw.githubusercontent.com/Majadigi-UB-Kelompok-10/majadigi-static-file/refs/heads/main/';

// Use GITHUB as fallback if SUPABASE fails
// dio.interceptors.add(InterceptorsWrapper(
//   onError: (DioException e, handler) async {
//     if (e.type == DioExceptionType.badResponse && e.response?.statusCode == 500) {
//       final options = e.requestOptions;
//       final fallback = e.requestOptions.extra['fallback'];
//       options.baseUrl = baseURLAlt;
//
//       if (fallback != null) {
//         options.path = fallback;
//       }
//
//       final response = await dio.fetch(options);
//       return handler.resolve(response);
//     }
//     return handler.next(e);
//   },
// ));

// ! Debugging Interceptor, REMOVE on prod
// dio.interceptors.add(LogInterceptor(
//   requestBody: true,
//   responseBody: true,
//   requestHeader: false,
// ));