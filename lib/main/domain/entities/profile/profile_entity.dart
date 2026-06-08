import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

/// Represent Profile Entity
@freezed
class ProfileEntity with _$ProfileEntity {
  const ProfileEntity({
    this.authId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.nik,
    this.address,
    this.birthDate,
    this.gender,
    this.role,
    this.isActive,
    this.updatedAt,
  });

  @override
  final String? authId;

  @override
  final String? firstName;

  @override
  final String? lastName;

  @override
  final String? phone;

  @override
  final String? email;

  @override
  final String? nik;

  @override
  final String? address;

  @override
  final String? birthDate;

  @override
  final String? gender;

  @override
  final String? role;

  @override
  final bool? isActive;

  @override
  final DateTime? updatedAt;
}