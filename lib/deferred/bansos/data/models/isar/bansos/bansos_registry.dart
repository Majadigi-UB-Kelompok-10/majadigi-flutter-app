import 'package:isar_community/isar.dart';
import '../../../../domain/entities/bansos/bansos_entity.dart';

part 'bansos_registry.g.dart';

@collection
class IsarBansosRegistry {
  Id? id; // FastHash(nik)
  
  @Index(unique: true, replace: true)
  String? nik;
  
  String? nama;
  String? alamat;
  
  List<IsarRiwayat>? riwayat;

  @ignore
  BansosEntity toEntity() {
    return BansosEntity(
      profil: ProfilEntity(
        nama: nama ?? '-',
        alamat: alamat ?? '-',
        nik: nik ?? '-',
      ),
      riwayat: riwayat?.map((r) => r.toEntity()).toList() ?? [],
    );
  }
}

@embedded
class IsarRiwayat {
  int? penyaluranId;
  String? programNama;
  String? periode;
  String? nominal;
  String? status;

  RiwayatEntity toEntity() {
    return RiwayatEntity(
      penyaluranId: penyaluranId ?? 0,
      programNama: programNama ?? '-',
      periode: periode ?? '-',
      nominal: nominal ?? '-',
      status: status ?? '-',
    );
  }
}
