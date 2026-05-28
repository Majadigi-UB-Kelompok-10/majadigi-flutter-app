import 'package:isar_community/isar.dart';
import '../../../../domain/entities/filter/jd_jenis_filter_entity.dart';

part 'jd_jenis_filter_registry.g.dart';

@collection
class IsarJdJenisFilterRegistry {
  Id isarId = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  String? value;

  String? label;

  JdJenisFilterEntity toEntity() {
    return JdJenisFilterEntity(
      value: value ?? '',
      label: label,
    );
  }
}
