import 'package:flutter_test/flutter_test.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/profile/profile_dto.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/profile/profile_registry.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/profile/profile_entity.dart';

void main() {
  group('ProfileDto Tests', () {
    const testJson = {
      'id': 'auth-123',
      'first_name': 'John',
      'last_name': 'Doe',
      'phone': '1234567890',
      'email': 'john.doe@example.com',
      'nik': '3500000000000001',
      'role': 'user',
      'is_active': true,
    };

    final testDto = ProfileDto(
      authId: 'auth-123',
      firstName: 'John',
      lastName: 'Doe',
      phone: '1234567890',
      email: 'john.doe@example.com',
      nik: '3500000000000001',
      role: 'user',
      isActive: true,
    );

    test('fromJson creates a valid ProfileDto instance', () {
      final dto = ProfileDto.fromJson(testJson);

      expect(dto.authId, 'auth-123');
      expect(dto.firstName, 'John');
      expect(dto.lastName, 'Doe');
      expect(dto.phone, '1234567890');
      expect(dto.email, 'john.doe@example.com');
      expect(dto.nik, '3500000000000001');
      expect(dto.role, 'user');
      expect(dto.isActive, true);
    });

    test('toJson returns a valid map', () {
      final json = testDto.toJson();

      expect(json, equals(testJson));
    });

    test('toIsar creates a valid IsarProfileRegistry object', () {
      final isarObj = testDto.toIsar();

      expect(isarObj, isA<IsarProfileRegistry>());
      expect(isarObj.authId, 'auth-123');
      expect(isarObj.firstName, 'John');
      expect(isarObj.lastName, 'Doe');
      expect(isarObj.phone, '1234567890');
      expect(isarObj.email, 'john.doe@example.com');
      expect(isarObj.nik, '3500000000000001');
      expect(isarObj.role, 'user');
      expect(isarObj.isActive, true);
    });

    test('fromEntity creates a valid ProfileDto object', () {
      final entity = ProfileEntity(
        authId: 'auth-123',
        firstName: 'John',
        lastName: 'Doe',
        phone: '1234567890',
        email: 'john.doe@example.com',
        nik: '3500000000000001',
        role: 'user',
        isActive: true,
        // Since Isar id is typically local, we might just test the core properties.
      );

      final dto = ProfileDto.fromEntity(entity);

      expect(dto.authId, 'auth-123');
      expect(dto.firstName, 'John');
      expect(dto.lastName, 'Doe');
      expect(dto.email, 'john.doe@example.com');
      expect(dto.isActive, true);
    });

    test('toIsar handles null optional fields gracefully with defaults', () {
      final minimalDto = ProfileDto(
        authId: 'auth-456',
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
        isActive: false,
        // Optional fields are omitted/null
      );

      final isarObj = minimalDto.toIsar();

      expect(isarObj.authId, 'auth-456');
      expect(isarObj.firstName, 'Jane');
      expect(isarObj.email, 'jane@example.com');
      expect(isarObj.phone, '');
      expect(isarObj.nik, '');
      expect(isarObj.role, '');
    });
  });
}
