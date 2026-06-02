import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/endpoint/endpoint_entity.dart';

part 'endpoint_registry.g.dart';

@collection
class IsarEndpointRegistry {
  // Due to unique replace index, getter will not work
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String slugName;

  late String pageUrl;

  late DateTime createdAt;

  @ignore
  EndpointEntity toEntity() {
    return EndpointEntity(
      id: id,
      slugName: slugName,
      pageUrl: pageUrl,
      createdAt: createdAt
    );
  }
}