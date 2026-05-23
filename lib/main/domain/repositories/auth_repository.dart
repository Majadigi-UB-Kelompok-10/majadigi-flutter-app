import 'package:majadigi_mobile_rebuild/main/domain/entities/auth/auth_entity.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

/// Represent Contracts for Authentication
abstract class AuthRepository {
  Future<AuthEntity?> login(String email, String password);
  Future<AuthEntity?> refreshLogin();
  Future<void> logout();
  Future<bool> isLoggedIn();

  // Profiles
  Future<ProfileEntity?> getProfile();
  Future<void> updateProfile(ProfileEntity entity);
  Future<void> updateLocalProfileOnly(ProfileEntity entity);
}