import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/profile/profile_dto.dart';
import 'package:zstandard/zstandard.dart';

import '../../../core/storage.dart' show SecureStorageKeys;
import '../decompression.dart';

/// Represent the Contract for Auth Remote Datasource.
/// Uses Public API Gateway (Dio)
abstract class AuthRemoteDatasource {
  Future<AuthEntity?> getRemoteAuth(String email, String password);
  Future<AuthEntity?> refreshRemoteAuth();
  Future<void> logout();
  Future<ProfileEntity?> getRemoteProfile();
  Future<void> updateRemoteProfile(ProfileEntity entity);
}

/// Represent the Auth Remote Datasource Implementation
class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  final FlutterSecureStorage secureStorage;
  AuthRemoteDatasourceImpl({required this.dio, this.zstandard, required this.secureStorage});

  @override
  Future<AuthEntity?> getRemoteAuth(String email, String password) async {
    final response = await dio.post("/user/auth/login", data: {
      'email': email,
      'password': password
    });

    if (response.statusCode != 200 || response.data == null) {
      return null;
    }

    final processedData = await cleanupData(zstandard: zstandard, response: response);
    final tokens = processedData["data"]["tokens"];

    if (tokens == null) {
      return null;
    }

    final accessToken = tokens[SecureStorageKeys.accessToken] as String?;
    final refreshToken = tokens[SecureStorageKeys.refreshToken] as String?;
    final tokenType = tokens[SecureStorageKeys.tokenType] as String?;

    return AuthEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  @override
  Future<void> logout() async {
    final refreshToken = await secureStorage.read(key: SecureStorageKeys.refreshToken);

    if (refreshToken == null) {
      return;
    }

    await dio.post("/user/auth/logout", data: {
      SecureStorageKeys.refreshToken: refreshToken
    });

    // Whether the response failed or not is not of concern
    return;
  }

  @override
  Future<AuthEntity?> refreshRemoteAuth() async {
    final refreshToken = await secureStorage.read(key: SecureStorageKeys.refreshToken);

    if (refreshToken == null) {
      return null;
    }

    final response = await dio.post("/user/auth/refresh", data: {
      SecureStorageKeys.refreshToken: refreshToken
    });

    if (response.statusCode != 200 || response.data == null) {
      return null;
    }

    final processedData = await cleanupData(zstandard: zstandard, response: response);
    final tokens = processedData["data"];

    if (tokens == null) {
      return null;
    }

    final newAccessToken = tokens[SecureStorageKeys.accessToken] as String?;
    final newRefreshToken = tokens[SecureStorageKeys.refreshToken] as String?;
    final newTokenType = tokens[SecureStorageKeys.tokenType] as String?;

    return AuthEntity(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      tokenType: newTokenType,
    );
  }

  @override
  Future<ProfileEntity?> getRemoteProfile() async {
    final response = await dio.get("/user/auth/me");

    if (response.statusCode != 200 || response.data == null) {
      return null;
    }

    final processedData = await cleanupData(zstandard: zstandard, response: response);
    final data = processedData["data"];

    if (data == null) {
      return null;
    }

    final dto = ProfileDto.fromJson(data);
    return dto.toIsar().toEntity();
  }

  @override
  Future<void> updateRemoteProfile(ProfileEntity entity) async {
    final response = await dio.put("/user/auth/me", data: {
      "first_name": entity.firstName,
      "last_name": entity.lastName,
      "phone": entity.phone,
      "nik": entity.nik,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to update profile");
    }
  }
}