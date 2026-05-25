import 'package:isar_community/isar.dart';

import '../../../../domain/entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';

part 'skp_detail_bahan_pokok_registry.g.dart';

@collection
class IsarSkpDetailBahanPokokRegistry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String slugId; // Use slug + tanggal as unique identifier for detail cache
  
  late String slug;
  late String queryTanggal;
  late String queryArea;

  late int bahanPokokId;
  late String komoditas;
  late String satuan;
  late String gambarUrl;
  late String tren;
  late String tanggal;
  late String tanggalDataAktual;
  late String areaPilihan;
  late double hargaUtama;

  late List<IsarSkpDataGrafik> grafikRiwayat;
  late List<IsarSkpDataKabKota> listKabKota;
  late IsarSkpDataStatistik statistik;

  @ignore
  SkpDetailBahanPokokEntity toEntity() {
    return SkpDetailBahanPokokEntity(
      id: bahanPokokId,
      komoditas: komoditas,
      slug: slug,
      satuan: satuan,
      gambarUrl: gambarUrl,
      tren: tren,
      tanggal: tanggal,
      tanggalDataAktual: tanggalDataAktual,
      areaPilihan: areaPilihan,
      hargaUtama: hargaUtama,
      grafikRiwayat: grafikRiwayat.map((e) => SkpDataGrafikEntity(
        tanggal: e.tanggal,
        rataRataHarga: e.rataRataHarga,
      )).toList(),
      listKabKota: listKabKota.map((e) => SkpDataKabKotaEntity(
        area: e.area,
        areaSlug: e.areaSlug,
        harga: e.harga,
      )).toList(),
      statistik: SkpDataStatistikEntity(
        tertinggi: SkpDataKabKotaEntity(
          area: statistik.tertinggi!.area,
          areaSlug: statistik.tertinggi!.areaSlug,
          harga: statistik.tertinggi!.harga,
        ),
        terendah: SkpDataKabKotaEntity(
          area: statistik.terendah!.area,
          areaSlug: statistik.terendah!.areaSlug,
          harga: statistik.terendah!.harga,
        ),
      ),
    );
  }
}

@embedded
class IsarSkpDataGrafik {
  late String tanggal;
  late double rataRataHarga;
}

@embedded
class IsarSkpDataKabKota {
  late String area;
  late String areaSlug;
  late double harga;
}

@embedded
class IsarSkpDataStatistik {
  IsarSkpDataKabKota? tertinggi;
  IsarSkpDataKabKota? terendah;
}
