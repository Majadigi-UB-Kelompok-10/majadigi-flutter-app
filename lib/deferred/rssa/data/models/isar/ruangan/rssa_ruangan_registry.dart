import 'package:isar_community/isar.dart';
import '../../../../domain/entities/ruangan/rssa_ruangan_entity.dart';

part 'rssa_ruangan_registry.g.dart';

@collection
class IsarRssaRuanganRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String compositeId; // e.g. "ruanganId_querySearch_queryKelas"
  
  late int ruanganId;
  
  @Index(type: IndexType.value, caseSensitive: false)
  late String nama;
  
  late String slug;
  late String kelasNama;
  late String kelasSlug;
  late int kapasitas;
  late int terisi;
  late int tersedia;

  @Index(type: IndexType.value)
  late String querySearch;
  
  @Index(type: IndexType.value)
  late String queryKelas;

  @ignore
  RssaRuanganEntity toEntity() {
    return RssaRuanganEntity(
      id: ruanganId,
      nama: nama,
      slug: slug,
      kelasNama: kelasNama,
      kelasSlug: kelasSlug,
      kapasitas: kapasitas,
      terisi: terisi,
      tersedia: tersedia,
    );
  }
}
