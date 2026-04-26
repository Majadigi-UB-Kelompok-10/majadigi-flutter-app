import 'package:dio/dio.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/core/storage.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/etag/etag_registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zstandard/zstandard.dart';

part 'http.g.dart';

/// Return the [Dio] instance for making HTTP requests.
@riverpod
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));

  return dio;
}

/// Return the [ZStandard] instance for compressing/decompressing data.
@riverpod
Zstandard zstandard(Ref ref) {
  return Zstandard();
}

/// Extension for dio to add zstd compression middleware.
@riverpod
void addZstdMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);

  // Create a InterceptorsWrapper Object
  final wrapper = InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Accept-Encoding'] = 'zstd';
      return handler.next(options);
    },
    onResponse: (response, handler) {
      if (response.headers.value('Content-Encoding') == 'zstd') {
        return handler.next(response.extra.putIfAbsent('zstd', () => true));
      }
      return handler.next(response.extra.putIfAbsent('zstd', () => false));
    },
  );

  // Check if the wrapper already exists before adding
  if (dio.interceptors.any((i) => i == wrapper)) {
    return;
  }

  // Add the wrapper to the dio interceptors
  dio.interceptors.add(wrapper);
}

/// Extension for Dio to Check ETags
@riverpod
void addETagMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);
  final isar = ref.watch(isarProvider);

  final wrapper = InterceptorsWrapper(
    onRequest: (options, handler) {
      if (options.method.toUpperCase() == 'GET') {
        return handler.next(options);
      }

      // ETag lookup
      final etagRecord = isar.isarEtagRegistrys
          .where()
          .endpointUrlEqualTo(options.uri.toString())
          .findFirstSync();

      if (etagRecord != null) {
        options.headers['If-None-Match'] = etagRecord.etag;
      }

      return handler.next(options);
    },
    onResponse: (response, handler) {
      if (response.statusCode == 200 &&
          response.headers.value('ETag') != null) {
        final etag = response.headers.value('ETag')!;

        final endpointUrl = response.requestOptions.uri.toString();

        isar.writeTxnSync(() {
          isar.isarEtagRegistrys.putSync(
            IsarEtagRegistry()
              ..endpointUrl = endpointUrl
              ..etag = etag,
          );
        });
      }
      return handler.next(response);
    },
  );

  // Check if the wrapper already exists before adding
  if (dio.interceptors.any((i) => i == wrapper)) {
    return;
  }

  dio.interceptors.add(wrapper);
}

/// Return the [SupabaseClient] instance for making Supabase requests.
@riverpod
SupabaseClient? supabase(Ref ref) {
  if (!Supabase.instance.isInitialized) {
    return null;
  }

  return Supabase.instance.client;
}
