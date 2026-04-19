import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/domain/entities/integration/integration_entity.dart';

part 'integration_registry.g.dart';

@collection
class IsarIntegrationRegistry {
  Id get isarId => fastHash(id);

  late String id;

  @Index()
  late String fkServiceListId;

  @Index()
  late String fkEndpointListId;

  late String title;

  late String iconUrl;

  late DateTime createdAt;

  @ignore
  IntegrationEntity toEntity() {
    return IntegrationEntity(
      id: id,
      fkServiceListId: fkServiceListId,
      fkEndpointListId: fkEndpointListId,
      title: title,
      iconUrl: iconUrl,
      createdAt: createdAt
    );
  }
}