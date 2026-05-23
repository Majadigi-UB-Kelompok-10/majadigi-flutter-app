import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<ProfileEntity?> build() async {
    final isAuthEnabled = ref.watch(authFeatureToggleProvider);
    final profile = await ref.watch(authRepositoryProvider).getProfile();

    if (!isAuthEnabled) {
      // Profile if guest have created before
      if (profile != null) {
        return profile;
      }

      // Template Profile if not exist
      return const ProfileEntity(
        authId: "GUEST",
        firstName: 'Majadigi',
        lastName: 'Guest',
        email: 'guest@majadigi.id',
        role: 'user',
        isActive: true
      );
    }

    // If online, will force actual profile with no fallback
    return profile;
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await ref.read(authRepositoryProvider).getProfile();
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProfile(ProfileEntity entity) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).updateProfile(entity);
      
      // Update state if success
      state = AsyncValue.data(entity);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateOfflineProfile(ProfileEntity entity) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(authRepositoryProvider).updateLocalProfileOnly(entity);

      state = AsyncValue.data(entity);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
