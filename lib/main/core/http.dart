import 'package:dio/dio.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/etag/etag_registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zstandard/zstandard.dart';

part 'http.g.dart';

// ---------------------------------------------------------------------------
// Private named interceptor subclasses — each has a unique type so the
// duplicate guard (i is _ZstdInterceptor / i is _ETagInterceptor) only
// matches its own kind, allowing both to coexist in dio.interceptors.
// ---------------------------------------------------------------------------

class _ZstdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.responseType = ResponseType.bytes;
    options.headers['Accept-Encoding'] = 'zstd';
    handler.next(options);
  }
}

class _ETagInterceptor extends Interceptor {
  const _ETagInterceptor({required this.isar});

  final Isar isar;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final etagRecord = isar.isarEtagRegistrys
        .where()
        .endpointUrlEqualTo(options.uri.toString())
        .findFirstSync();

    if (etagRecord != null) {
      options.headers['If-None-Match'] = etagRecord.etag;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 && response.headers.value('etag') != null) {
      final etag = response.headers.value('etag')!;
      final endpointUrl = response.requestOptions.uri.toString();

      await isar.writeTxn(() async {
        await isar.isarEtagRegistrys.put(
          IsarEtagRegistry()
            ..endpointUrl = endpointUrl
            ..etag = etag,
        );
      });
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 304) {
      handler.resolve(Response(
        requestOptions: err.requestOptions,
        statusCode: 304,
        data: null,
        statusMessage: 'Not Modified',
      ));
      return;
    }

    handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Return the [Dio] instance for making HTTP requests.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(BaseOptions(connectTimeout: const Duration(seconds: 3)));
}

/// Return the [Zstandard] instance for compressing/decompressing data.
@Riverpod(keepAlive: true)
Zstandard zstandard(Ref ref) {
  return Zstandard();
}

/// Registers the zstd [_ZstdInterceptor] on [Dio] exactly once.
@Riverpod(keepAlive: true)
void addZstdMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);

  if (dio.interceptors.any((i) => i is _ZstdInterceptor)) {
    return;
  }

  dio.interceptors.add(_ZstdInterceptor());
}

/// Registers the ETag [_ETagInterceptor] on [Dio] exactly once.
@Riverpod(keepAlive: true)
void addETagMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);
  final isar = ref.watch(isarProvider);

  if (dio.interceptors.any((i) => i is _ETagInterceptor)) {
    return;
  }

  dio.interceptors.add(_ETagInterceptor(isar: isar));
}

/// Return the [SupabaseClient] instance for making Supabase requests.
@riverpod
SupabaseClient? supabase(Ref ref) {
  if (!Supabase.instance.isInitialized) {
    return null;
  }

  return Supabase.instance.client;
}

/// Base URL for Supabase
const supabaseBaseUrl = "https://nhsdrdhzkogczngslvvh.supabase.co/storage/v1/object/public/";

/// Variant URL for supabase
const supabaseImageUrl = "image-asset/";
