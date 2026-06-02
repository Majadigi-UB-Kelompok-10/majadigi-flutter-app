import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';

part 'integration_registry.g.dart';

@collection
class IsarIntegrationRegistry {
  // Due to unique replace index, getter will not work
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index(composite: [CompositeIndex('fkEndpointListId')])
  late String fkServiceListId;

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