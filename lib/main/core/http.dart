import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/core/credentials.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/etag/etag_registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zstandard/zstandard.dart';

part 'http.g.dart';

// ---------------------------------------------------------------------------
// Private named interceptor subclasses — each has a unique type so the
// duplicate guard (i is _ZstdInterceptor / i is _ETagInterceptor) only
// matches its own kind, allowing both to coexist in dio.interceptors.
// ---------------------------------------------------------------------------

/// Zstandard Interceptor
class _ZstdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.responseType = ResponseType.bytes;
    options.headers['Accept-Encoding'] = 'zstd';
    handler.next(options);
  }
}

/// ETag Interceptor
class _ETagInterceptor extends Interceptor {
  const _ETagInterceptor({required this.isar});

  final Isar isar;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    // Whitelist ETagging from favorites
    if (options.path.contains('/user/auth/favorites')) {
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

/// Authorization Bearer Token Interceptor
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Ref ref;
  final Dio dio;

  // Concurrency Lock
  Future<void>? _refreshTask;

  _AuthInterceptor({
    required this.secureStorage,
    required this.ref,
    required this.dio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final tokenType = await secureStorage.read(key: SecureStorageKeys.tokenType);

    if (token != null) {
      options.headers['Authorization'] = '$tokenType $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final requestOptions = err.requestOptions;

    // Prevent the refresh endpoint from triggering a refresh loop
    final isRefreshEndpoint = requestOptions.path.contains('/user/auth/refresh');

    if (response?.statusCode == 401 && !isRefreshEndpoint) {

      // Put a hard limit on retries (Original request + 1 Retry)
      final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;

      if (retryCount >= 1) {
        // If it has already been retried once and still failed with 401, reject it immediately.
        return handler.next(err);
      }

      try {
        // Handle Concurrency: If a refresh is already happening, just wait for it to finish.
        if (_refreshTask != null) {
          await _refreshTask;
        } else {
          // If no refresh is happening, start one and attach it to the variable
          _refreshTask = ref.read(authProvider.notifier).refresh().whenComplete(() {
            // Ensure the lock is cleared when the refresh finishes (success or fail)
            _refreshTask = null;
          });
          await _refreshTask;
        }

        // Verify the refresh was actually successful
        final isLoggedIn = ref.read(authProvider).value ?? false;
        final newToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
        final tokenType = await secureStorage.read(key: SecureStorageKeys.tokenType);

        if (!isLoggedIn || newToken == null) {
          return handler.reject(err);
        }

        // Increment the retry count so it doesn't get stuck in a loop if the new token is also rejected
        requestOptions.extra['retry_count'] = retryCount + 1;
        requestOptions.headers['Authorization'] = '$tokenType $newToken';

        // Retry the request
        final retryResponse = await dio.fetch(requestOptions);
        return handler.resolve(retryResponse);

      } on DioException catch (e) {
        return handler.next(e);
      } catch (e) {
        return handler.reject(err);
      }
    }

    // If it's not a 401, or it is the refresh endpoint failing, just pass the error along
    return handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Return the [Dio] instance for making HTTP requests.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
      baseUrl: Credentials.baseUrl
    )
  );
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

/// Returns a [Dio] instance with the [_AuthInterceptor] registered.
@Riverpod(keepAlive: true)
void addAuthMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  if (dio.interceptors.any((i) => i is _AuthInterceptor)) {
    return;
  }

  dio.interceptors.add(_AuthInterceptor(secureStorage: secureStorage, ref: ref, dio: dio));
}

/// Disable the [_AuthInterceptor] Middleware in [Dio]
@Riverpod(keepAlive: true)
void removeAuthMiddleware(Ref ref) {
  final dio = ref.watch(dioProvider);

  dio.interceptors.removeWhere((i) => i is _AuthInterceptor);
}
