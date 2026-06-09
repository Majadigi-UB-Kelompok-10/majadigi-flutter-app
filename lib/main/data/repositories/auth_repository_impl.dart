import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/register/register_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/auth_repository.dart';

import 'package:flutter/material.dart' show debugPrint;

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.localDatasource, required this.remoteDatasource});

  @override
  Future<ProfileEntity?> getProfile() async {
    try {
      final remoteProfile = await remoteDatasource.getRemoteProfile();
      if (remoteProfile != null) {
        await localDatasource.updateLocalProfile(remoteProfile);
        return remoteProfile;
      }
    } catch (e) {
      // Ignore remote errors and fallback to local
    }
    
    return await localDatasource.getLocalProfile();
  }

  @override
  Future<void> updateProfile(ProfileEntity entity) async {
    // Strictly need to fail on online mode
    await remoteDatasource.updateRemoteProfile(entity);
    await localDatasource.updateLocalProfile(entity);
  }

  @override
  Future<void> updateLocalProfileOnly(ProfileEntity entity) async {
    // This is meant for offline guest usage ONLY
    await localDatasource.updateLocalProfile(entity);
  }

  @override
  Future<AuthEntity?> login(String email, String password) async {
    final AuthEntity? entity = await remoteDatasource.getRemoteAuth(email, password);

    if (entity == null) {
      return null;
    }

    // Set local auth
    await localDatasource.setLocalAuth(entity);

    return entity;
  }

  @override
  Future<void> logout() async {
    // Remove from remote (Fire and Forget)
    try {
      await remoteDatasource.logout();
    } catch (e) { /* Continue */ }

    // Remove from local
    await localDatasource.removeLocalAuth();
    await localDatasource.clearProfile();
  }

  // To prevent duplicate
  Future<AuthEntity?>? _refreshFuture;

  @override
  Future<AuthEntity?> refreshLogin() async {
    if (_refreshFuture != null) {
      debugPrint("Refresh already in progress, waiting for it...");
      return _refreshFuture!;
    }

    // Refresh from remote
    _refreshFuture = _performRefreshLogin().whenComplete(() {
      _refreshFuture = null;
    });

    return _refreshFuture!;
  }

  Future<AuthEntity?> _performRefreshLogin() async {
    debugPrint("Attempting to refresh from remote...");
    final AuthEntity? entity = await remoteDatasource.refreshRemoteAuth();
    debugPrint("refreshRemoteAuth fetched: ${entity != null}");

    if (entity == null) return null;

    debugPrint("Renewing local auth token");
    await localDatasource.setLocalAuth(entity);

    debugPrint("Returning the refreshed entity token.");
    return entity;
  }

  @override
  Future<bool> isLoggedIn() async {
    // Check if local have tokens
    debugPrint("isLoggedIn() is Called: Attempting to check auth...");
    final AuthEntity entity = await localDatasource.getLocalAuth();

    debugPrint("Local auth token fetched: ${entity.accessToken}");
    if (entity.accessToken == null || entity.accessToken!.isEmpty) {
      return false;
    }

    debugPrint("Attempting to Refresh Token...");
    // Attempt to Refresh Token
    try {
      final refreshedEntity = await refreshLogin();

      return refreshedEntity != null;
    } catch (e) {
      // If token refresh failed or unable to reach network
      debugPrint("Token refresh failed with error: ${e.toString()}");

      // Attempt to check whether there is a profile in local
      final profile = await localDatasource.getLocalProfile();

      if (profile != null && profile.authId != null) {
        return true;
      }

      return false;
    }
  }

  @override
  Future<(bool, String)> register(RegisterEntity entity) async {
    return await remoteDatasource.register(entity);
  }

  @override
  Future<bool> resendEmailVerification(String email) async {
    return await remoteDatasource.resendEmailVerification(email);
  }

  @override
  Future<bool> resetPassword(String email) async {
    return await remoteDatasource.resetPassword(email);
  }

  @override
  Future<(bool, String)> setNewPassword(String token, String newPassword, String confirmNewPassword) async {
    return await remoteDatasource.setNewPassword(token, newPassword, confirmNewPassword);
  }
}