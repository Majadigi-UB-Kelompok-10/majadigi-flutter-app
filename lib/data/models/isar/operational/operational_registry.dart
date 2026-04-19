import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/operational/operational_entity.dart';

part 'operational_registry.g.dart';

@collection
class IsarOperationalRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index(unique: true)
  late String fkServiceListId;

  late String serviceUrl;

  late String address;

  late String rawOperationalHour;

  late String rawSocialMedia;

  late DateTime createdAt;

  @ignore
  Map<String, dynamic> get jsonOperationalHourData {
    if (rawOperationalHour.isEmpty) return {};
    return jsonDecode(rawOperationalHour) as Map<String, dynamic>;
  }

  @ignore
  set jsonOperationalHourData(Map<String, dynamic> value) {
    rawOperationalHour = jsonEncode(value);
  }

  @ignore
  Map<String, dynamic> get jsonSocialMediaData {
    if (rawSocialMedia.isEmpty) return {};
    return jsonDecode(rawSocialMedia) as Map<String, dynamic>;
  }

  @ignore
  set jsonSocialMediaData(Map<String, dynamic> value) {
    rawSocialMedia = jsonEncode(value);
  }

  @ignore
  OperationalEntity toEntity() {
    return OperationalEntity(
      id: id,
      fkServiceListId: fkServiceListId,
      serviceUrl: serviceUrl,
      address: address,
      operationalHour: jsonOperationalHourData,
      socialMedia: jsonSocialMediaData,
      createdAt: createdAt
    );
  }
}