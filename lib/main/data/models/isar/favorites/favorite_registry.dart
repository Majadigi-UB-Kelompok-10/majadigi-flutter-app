import 'package:isar_community/isar.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/isar/service/service_registry.dart';

part 'favorite_registry.g.dart';

@collection
class IsarFavoriteRegistry {
  Id isarId = Isar.autoIncrement;

  String id = "favorites";

  final fkServiceId = IsarLinks<IsarServiceRegistry>();

  DateTime lastUpdated = DateTime.now().toUtc();
}