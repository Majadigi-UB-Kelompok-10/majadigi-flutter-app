import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

part 'profile_registry.g.dart';

@collection
class IsarProfileRegistry {
  Id get isarId => fastHash(id);

  String id = "profile";

  late String authId;

  late String firstName;

  late String lastName;

  late String? phone;

  late String email;

  late String? nik;

  late String? address;

  late String? role;

  late bool isActive;

  @ignore
  ProfileEntity toEntity() {
    return ProfileEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      nik: nik,
      address: address,
      role: role,
      isActive: isActive
    );
  }
}