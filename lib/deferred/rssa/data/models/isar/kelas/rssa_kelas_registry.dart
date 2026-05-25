import 'package:isar_community/isar.dart';
import '../../../../domain/entities/kelas/rssa_kelas_entity.dart';

part 'rssa_kelas_registry.g.dart';

@collection
class IsarRssaKelasRegistry {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  late int kelasId;
  
  late String nama;
  late String slug;

  @ignore
  RssaKelasEntity toEntity() {
    return RssaKelasEntity(
      id: kelasId,
      nama: nama,
      slug: slug,
    );
  }
}
