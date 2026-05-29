import 'package:isar_community/isar.dart';
import '../../../../domain/entities/blk/snk_blk_entity.dart';

part 'snk_blk_registry.g.dart';

@collection
class IsarSnkBlkRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int blkId;

  late String nama;
  late String alamat;
  late String kabKota;
  late String kecamatan;
  late String slug;
  double? lat;
  double? lng;

  @ignore
  SnkBlkEntity toEntity() {
    return SnkBlkEntity(
      id: blkId,
      nama: nama,
      alamat: alamat,
      kabKota: kabKota,
      kecamatan: kecamatan,
      slug: slug,
      lat: lat,
      lng: lng,
    );
  }
}
