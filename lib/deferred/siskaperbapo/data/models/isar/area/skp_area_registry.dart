import 'package:isar_community/isar.dart';
import '../../../../domain/entities/area/skp_area_entity.dart';

part 'skp_area_registry.g.dart';

@collection
class IsarSkpAreaRegistry {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  late int areaId;
  
  late String nama;
  late String slug;

  @ignore
  SkpAreaEntity toEntity() {
    return SkpAreaEntity(
      id: areaId,
      nama: nama,
      slug: slug,
    );
  }
}
