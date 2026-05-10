import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/fast_hash.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';

part 'favorite_registry.g.dart';

@collection
class IsarFavoriteRegistry {
  Id get isarId => fastHash(id);

  late String id;

  final fkServiceId = IsarLinks<IsarServiceRegistry>();

  DateTime lastUpdated = DateTime.now();
}