import 'package:isar_community/isar.dart';

part 'etag_registry.g.dart';

@Collection()
class IsarEtagRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String endpointUrl = '';

  late String etag = '';
}
