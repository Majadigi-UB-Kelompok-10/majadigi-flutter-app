import 'package:isar_community/isar.dart';

part 'etag_registry.g.dart';

@Collection()
class IsarEtagRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String endpointUrl = '';

  late String etag = '';
}
