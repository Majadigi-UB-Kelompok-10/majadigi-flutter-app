import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.freezed.dart';

/// Represent Simple Auth Entity
@freezed
class AuthEntity with _$AuthEntity {
  const AuthEntity({
    this.accessToken,
    this.refreshToken,
    this.tokenType
  });

  @override
  final String? accessToken;

  @override
  final String? refreshToken;

  @override
  final String? tokenType;
}