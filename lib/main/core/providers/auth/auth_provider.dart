import 'package:flutter/material.dart' show ChangeNotifier, BuildContext;
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/repositories/auth_repository_impl.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Local Datasource for Auth
@riverpod
AuthLocalDatasource _authLocalDatasource(Ref ref) {
  return AuthLocalDatasourceImpl(ref.watch(secureStorageProvider), ref.watch(isarProvider));
}

/// Remote Datasource for Auth
@riverpod
AuthRemoteDatasource _authRemoteDatasource(Ref ref) {
  return AuthRemoteDatasourceImpl(
    dio: ref.watch(dioProvider),
    zstandard: ref.watch(zstandardProvider),
    secureStorage: ref.watch(secureStorageProvider)
  );
}

/// Repository for Auth
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    localDatasource: ref.watch(_authLocalDatasourceProvider),
    remoteDatasource: ref.watch(_authRemoteDatasourceProvider)
  );
}

/// Notifier
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<bool> build() async {
    return ref.watch(authRepositoryProvider).isLoggedIn();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final AuthEntity? entity = await ref.read(authRepositoryProvider).login(email, password);

      if (entity == null) {
        throw Exception("Failed to get token");
      }

      state = const AsyncValue.data(true);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      final AuthEntity? entity = await ref.read(authRepositoryProvider).refreshLogin();

      if (entity == null) {
        // Failed to refresh so logout
        await logout();
      } else {
        state = const AsyncValue.data(true);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    await ref.read(authRepositoryProvider).logout();

    state = const AsyncValue.data(false);
  }
}

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to auth changes and notify GoRouter's refreshListenable
    _ref.listen<AsyncValue<bool>>(authProvider, (previous, next) {
        // Short circuit if auth is off
        if (!_ref.read(authFeatureToggleProvider)) return;

        if (previous?.value != next.value || next.isLoading != previous?.isLoading) {
          notifyListeners();
        }
      },
    );

    // Listen to Auth Toggler
    _ref.listen<bool>(authFeatureToggleProvider, (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      }
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isAuthEnabled = _ref.read(authFeatureToggleProvider);

    // If authentication is globally disabled via the feature toggle, skip redirection logic.
    if (!isAuthEnabled) return null;

    final authState = _ref.read(authProvider);

    // Prevent redirecting while the provider is initially reading from secure storage
    if (authState.isLoading || !authState.hasValue) {
      return null;
    }

    // Safely unwrap the boolean. Defaults to false (logged out) if something goes wrong.
    final isLoggedIn = authState.value ?? false;
    final isLoggingIn = state.matchedLocation == '/onboarding';

    // Page Exclusion from redirect to Login Page
    final List<String> excludedPage = ['/', '/onboarding', '/login', '/register', '/example'];
    final isExcluded = excludedPage.contains(state.matchedLocation);

    if (!isLoggedIn && !isExcluded) {
      // If the user isn't logged in, redirect to onboarding unless they are already there
      return isLoggingIn ? null : '/onboarding';
    }

    if (isLoggedIn && isLoggingIn) {
      // If the user is logged in but tries to access the login page, send them home
      return '/homepage';
    }

    return null;
  }
}

// Provide the bridge
@riverpod
RouterNotifier routerNotifier(Ref ref) => RouterNotifier(ref);

/// Auth Toggler
@riverpod
class AuthFeatureToggle extends _$AuthFeatureToggle {
  @override
  bool build() {
    return false;
  }

  void enableAuth() => state = true;
  void disableAuth() => state = false;
  void toggleAuth() => state = !state;
}

/// Guest Toggler
@riverpod
class GuestStatus extends _$GuestStatus {
  @override
  Future<bool> build() async {
    final secureStorage = ref.watch(secureStorageProvider);

    final status = await secureStorage.read(key: SecureStorageKeys.guestMode);

    if (status != null && status.isNotEmpty) {
      return true;
    }

    return false;
  }

  void enableGuest() async {
    final secureStorage = ref.watch(secureStorageProvider);

    await secureStorage.write(key: SecureStorageKeys.guestMode, value: 'true');
  }

  void disableGuest() async {
    final secureStorage = ref.watch(secureStorageProvider);

    await secureStorage.delete(key: SecureStorageKeys.guestMode);
  }
}