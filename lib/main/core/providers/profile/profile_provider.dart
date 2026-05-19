import 'package:majadigi_mobile_rebuild/main/core/providers/auth/auth_provider.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<ProfileEntity?> build() async {
    return ref.watch(authRepositoryProvider).getProfile();
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
}
