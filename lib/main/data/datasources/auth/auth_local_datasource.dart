import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart' show SecureStorageKeys;
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/profile/profile_registry.dart';

/// Represent the Contract for Auth Local Datasource.
/// Uses only Flutter Secure Storage Package
abstract class AuthLocalDatasource {
  Future<AuthEntity> getLocalAuth();
  Future<void> setLocalAuth(AuthEntity entity);
  Future<void> removeLocalAuth();
  Future<ProfileEntity?> getLocalProfile();
  Future<void> updateLocalProfile(ProfileEntity entity);
  Future<void> clearProfile();
}

/// Represent the Auth Local Datasource Implementation
class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final FlutterSecureStorage _secureStorage;
  final Isar _isar;
  AuthLocalDatasourceImpl(this._secureStorage, this._isar);

  @override
  Future<AuthEntity> getLocalAuth() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final refreshToken = await _secureStorage.read(key: SecureStorageKeys.refreshToken);
    final tokenType = await _secureStorage.read(key: SecureStorageKeys.tokenType);

    return AuthEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType
    );
  }

  @override
  Future<void> removeLocalAuth() async {
    await Future.wait([
      _secureStorage.delete(key: SecureStorageKeys.accessToken),
      _secureStorage.delete(key: SecureStorageKeys.refreshToken),
      _secureStorage.delete(key: SecureStorageKeys.tokenType)
    ]);
  }

  @override
  Future<void> setLocalAuth(AuthEntity entity) async {
    await Future.wait([
      _secureStorage.write(
        key: SecureStorageKeys.accessToken,
        value: entity.accessToken,
      ),
      _secureStorage.write(
        key: SecureStorageKeys.refreshToken,
        value: entity.refreshToken,
      ),
      _secureStorage.write(
        key: SecureStorageKeys.tokenType,
        value: entity.tokenType,
      )
    ]);
  }

  @override
  Future<void> clearProfile() async {
    await _isar.writeTxn(() async {
      await _isar.isarProfileRegistrys.clear();
    });
  }

  @override
  Future<ProfileEntity?> getLocalProfile() async {
    final profile = await _isar.isarProfileRegistrys.where().findFirst();
    return profile?.toEntity();
  }

  @override
  Future<void> updateLocalProfile(ProfileEntity entity) async {
    final isarObj = IsarProfileRegistry()
      ..authId = entity.authId!
      ..firstName = entity.firstName!
      ..lastName = entity.lastName!
      ..email = entity.email!
      ..phone = entity.phone
      ..nik = entity.nik
      ..address = entity.address
      ..role = entity.role
      ..isActive = entity.isActive!;
      
    await _isar.writeTxn(() async {
      await _isar.isarProfileRegistrys.put(isarObj);
    });
  }
}