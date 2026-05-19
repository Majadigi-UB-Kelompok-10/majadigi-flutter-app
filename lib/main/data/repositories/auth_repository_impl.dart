import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_local_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/auth/auth_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/repositories/auth_repository.dart';

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
    } catch (_) {
      // Ignore remote errors and fallback to local
    }
    
    return await localDatasource.getLocalProfile();
  }

  @override
  Future<void> updateProfile(ProfileEntity entity) async {
    await remoteDatasource.updateRemoteProfile(entity);
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
    // Remove from remote
    await remoteDatasource.logout();

    // Remove from local
    await localDatasource.removeLocalAuth();
    await localDatasource.clearProfile();
  }

  @override
  Future<AuthEntity?> refreshLogin() async {
    // Refresh from remote
    final AuthEntity? entity = await remoteDatasource.refreshRemoteAuth();

    if (entity == null) {
      return null;
    }

    // Set local auth
    await localDatasource.setLocalAuth(entity);

    return entity;
  }

  @override
  Future<bool> isLoggedIn() async {
    // Check if local have tokens
    final AuthEntity entity = await localDatasource.getLocalAuth();

    if (entity.accessToken == null || entity.accessToken!.isEmpty) {
      return false;
    }
    
    return true;
  }
}