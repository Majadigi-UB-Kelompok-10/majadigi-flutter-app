import 'package:isar_community/isar.dart';

part 'sd_event_year_registry.g.dart';

@collection
class IsarSdEventYearRegistry {
  Id get isarId => tahun;

  @Index(unique: true, replace: true)
  late int tahun;
}
