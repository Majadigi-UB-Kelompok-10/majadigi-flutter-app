import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/profile/profile_registry.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

/// Model for JSON to Profile Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class ProfileDto with _$ProfileDto {
  const ProfileDto({
    this.authId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.nik,
    this.role,
    this.isActive
  });

  @override
  @JsonKey(name: 'id')
  final String? authId;

  @override
  @JsonKey(name: 'first_name')
  final String? firstName;

  @override
  @JsonKey(name: 'last_name')
  final String? lastName;

  @override
  @JsonKey(name: 'phone')
  final String? phone;

  @override
  @JsonKey(name: 'email')
  final String? email;

  @override
  @JsonKey(name: 'nik')
  final String? nik;

  @override
  @JsonKey(name: 'role')
  final String? role;

  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  // Json Serializable
  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);

  @ignore
  factory ProfileDto.fromEntity(ProfileEntity entity) {
    return ProfileDto(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      email: entity.email,
      nik: entity.nik,
      role: entity.role,
      isActive: entity.isActive,
    );
  }

  @ignore
  IsarProfileRegistry toIsar() {
    return IsarProfileRegistry()
      ..authId = authId!
      ..firstName = firstName!
      ..lastName = lastName!
      ..email = email!
      ..phone = phone ?? ''
      ..nik = nik ?? ''
      ..role = role ?? ''
      ..isActive = isActive!;
  }
}
