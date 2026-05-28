import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_entity.freezed.dart';

/// Represent Register Entity
@freezed
class RegisterEntity with _$RegisterEntity {
  const RegisterEntity({
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.nik,
    this.address,
    this.birthDate,
    this.gender,
    this.password,
    this.confirmPassword,
  });

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
  final String? password;

  @override
  final String? confirmPassword;
}