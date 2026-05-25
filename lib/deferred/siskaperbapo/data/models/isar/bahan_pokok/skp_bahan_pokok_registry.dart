import 'package:isar_community/isar.dart';

import '../../../../domain/entities/bahan_pokok/skp_bahan_pokok_entity.dart';

part 'skp_bahan_pokok_registry.g.dart';

@collection
class IsarSkpBahanPokokRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String compositeId;

  late int bahanPokokId;

  late String komoditas;
  late String slug;
  late String satuan;
  late String gambarUrl;
  late String tren;
  late double hargaSekarang;
  
  // Storing parameters to allow querying specific lists
  @Index()
  late String queryTanggal;
  @Index()
  late String queryBahanPokok;
  @Index()
  late String queryArea;

  @ignore
  SkpBahanPokokEntity toEntity() {
    return SkpBahanPokokEntity(
      id: bahanPokokId,
      komoditas: komoditas,
      slug: slug,
      satuan: satuan,
      gambarUrl: gambarUrl,
      tren: tren,
      hargaSekarang: hargaSekarang,
    );
  }
}
