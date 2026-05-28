import 'package:isar_community/isar.dart';
import '../../../../domain/entities/pengumuman/jd_pengumuman_entity.dart';

part 'jd_pengumuman_registry.g.dart';

@collection
class IsarJdPengumumanRegistry {
  Id? id;

  String? judul;
  String? isi;
  String? tanggal;

  JdPengumumanEntity toEntity() {
    return JdPengumumanEntity(
      id: id ?? 0,
      judul: judul,
      isi: isi,
      tanggal: tanggal,
    );
  }
}
