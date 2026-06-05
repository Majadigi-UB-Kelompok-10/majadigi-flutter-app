import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/profile/profile_dto.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/register/register_entity.dart';
import 'package:zstandard/zstandard.dart';

import '../../../core/storage.dart' show SecureStorageKeys;
import '../decompression.dart';

/// Represent the Contract for Auth Remote Datasource.
/// Uses Public API Gateway (Dio)
abstract class AuthRemoteDatasource {
  Future<AuthEntity?> getRemoteAuth(String email, String password);
  Future<AuthEntity?> refreshRemoteAuth();
  Future<void> logout();
  Future<(bool, String)> register(RegisterEntity entity);
  Future<bool> resendEmailVerification(String email);
  Future<bool> resetPassword(String email);
  Future<(bool, String)> setNewPassword(String token, String newPassword, String confirmNewPassword);
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
    final response = await dio.put("/user/auth/me", data: ProfileDto.fromEntity(entity).toJson());

    if (response.statusCode != 200) {
      throw Exception("Failed to update profile");
    }
  }

  @override
  Future<(bool, String)> register(RegisterEntity entity) async {
    Map<String, dynamic> data = {
      "first_name": entity.firstName.toString().trim(),
      "last_name": entity.lastName.toString().trim(),
      "phone": entity.phone.toString().trim(),
      "nik": entity.nik.toString().trim(),
      "email": entity.email.toString().trim(),
      "address": entity.address.toString().trim(),
      "birth_date": entity.birthDate.toString().trim(),
      "gender": entity.gender.toString().trim(),
      "password": entity.password.toString().trim(),
      "confirm_password": entity.confirmPassword.toString().trim()
    };

    final response = await dio.post(
        "/user/auth/register",
        data: data,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    final processedData = await cleanupData(response: response, zstandard: zstandard);

    if (processedData == null) {
      return (false, "No Response From Backend");
    }

    if (response.statusCode != 201) {
      final statusCode = response.statusCode.toString();
      final message = processedData["message"] ?? "Unknown error occurred";

      return (false, "Failed to register [$statusCode]: $message");
    }

    return (true, "${entity.email} is Successfully registered");
  }

  @override
  Future<bool> resendEmailVerification(String email) async {
    final response = await dio.post("/user/auth/resend-verification", data: {
      "email": email
    });

    if (response.statusCode != 200) return false;

    return true;
  }

  @override
  Future<bool> resetPassword(String email) async {
    final response = await dio.post("/user/auth/forgot-password", data: {
      "email": email
    });
    
    if (response.statusCode != 200) return false;
    
    return true;
  }

  @override
  Future<(bool, String)> setNewPassword(String token, String newPassword, String confirmNewPassword) async {
    final response = await dio.post("/user/auth/reset-password", data: {
      "token": token,
      "new_password": newPassword,
      "confirm_new_password": confirmNewPassword
    });

    if (response.statusCode != 200) {
      final data = await cleanupData(response: response, zstandard: zstandard);

      final message = data["message"] as String?;

      if (message == null || message.isEmpty) {
        return (false, "Something Went Wrong");
      }

      return (false, message);
    }

    return (true, "Success");
  }
}