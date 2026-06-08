import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

part 'profile_registry.g.dart';

@collection
class IsarProfileRegistry {
  Id isarId = Isar.autoIncrement;

  String id = "profile";

  late String authId;

  late String firstName;

  late String lastName;

  late String? phone;

  late String email;

  late String? nik;

  late String? address;

  late String? birthDate;

  late String? gender;

  late String? role;

  late bool isActive;

  late DateTime? updatedAt;

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
      birthDate: birthDate,
      gender: gender,
      role: role,
      isActive: isActive,
      updatedAt: updatedAt
    );
  }
}