import '../../domain/entities/area/skp_area_entity.dart';
import '../../domain/entities/bahan_pokok/skp_bahan_pokok_entity.dart';
import '../../domain/entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';
import '../../domain/repositories/skp_repository.dart';
import '../datasources/skp_local_datasource.dart';
import '../datasources/skp_remote_datasource.dart';
import '../models/dto/area/area_dto.dart';
import '../models/dto/bahan_pokok/bahan_pokok_dto.dart';
import '../models/isar/area/skp_area_registry.dart';
import '../models/isar/bahan_pokok/skp_bahan_pokok_registry.dart';
import '../models/isar/bahan_pokok/skp_detail_bahan_pokok_registry.dart';

extension AreaDtoToIsar on AreaDto {
  IsarSkpAreaRegistry toIsar() {
    return IsarSkpAreaRegistry()
      ..areaId = id
      ..nama = nama ?? ''
      ..slug = slug ?? '';
  }
}

extension BahanPokokDtoToIsar on BahanPokokDto {
  IsarSkpBahanPokokRegistry toIsar({required String qTanggal, required String qBahanPokok, required String qArea}) {
    return IsarSkpBahanPokokRegistry()
      ..compositeId = '${id}_${qTanggal}_${qBahanPokok}_${qArea}'
      ..bahanPokokId = id
      ..komoditas = komoditas ?? ''
      ..slug = slug ?? ''
      ..satuan = satuan ?? ''
      ..gambarUrl = gambarUrl ?? ''
      ..tren = tren ?? ''
      ..hargaSekarang = hargaSekarang ?? 0.0
      ..queryTanggal = qTanggal
      ..queryBahanPokok = qBahanPokok
      ..queryArea = qArea;
  }
}

extension DetailBahanPokokDtoToIsar on DetailBahanPokokDto {
  IsarSkpDetailBahanPokokRegistry toIsar({required String queryTanggal, required String queryArea}) {
    return IsarSkpDetailBahanPokokRegistry()
      ..slugId = '${slug ?? ''}_${queryTanggal}_$queryArea'
      ..slug = slug ?? ''
      ..queryTanggal = queryTanggal
      ..queryArea = queryArea
      ..bahanPokokId = id
      ..komoditas = komoditas ?? ''
      ..satuan = satuan ?? ''
      ..gambarUrl = gambarUrl ?? ''
      ..tren = tren ?? ''
      ..tanggal = tanggal ?? ''
      ..tanggalDataAktual = tanggalDataAktual ?? ''
      ..areaPilihan = areaPilihan ?? ''
      ..hargaUtama = hargaUtama ?? 0.0
      ..grafikRiwayat = grafikRiwayat?.map((e) => IsarSkpDataGrafik()
        ..tanggal = e.tanggal ?? ''
        ..rataRataHarga = e.rataRataHarga ?? 0.0
      ).toList() ?? []
      ..listKabKota = listKabKota?.map((e) => IsarSkpDataKabKota()
        ..area = e.area ?? ''
        ..areaSlug = e.areaSlug ?? ''
        ..harga = e.harga ?? 0.0
      ).toList() ?? []
      ..statistik = (IsarSkpDataStatistik()
        ..tertinggi = (IsarSkpDataKabKota()
          ..area = statistik?.tertinggi?.area ?? ''
          ..areaSlug = statistik?.tertinggi?.areaSlug ?? ''
          ..harga = statistik?.tertinggi?.harga ?? 0.0)
        ..terendah = (IsarSkpDataKabKota()
          ..area = statistik?.terendah?.area ?? ''
          ..areaSlug = statistik?.terendah?.areaSlug ?? ''
          ..harga = statistik?.terendah?.harga ?? 0.0));
  }
}

class SkpRepositoryImpl implements SkpRepository {
  final SkpLocalDatasource local;
  final SkpRemoteDatasource remote;

  SkpRepositoryImpl({required this.local, required this.remote});

  @override
  Stream<List<SkpAreaEntity>> getAreas() {
    return local.watchAreas().map((list) => list.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<List<SkpBahanPokokEntity>> getBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''}) {
    return local.watchBahanPokok(tanggal: tanggal, bahanPokok: bahanPokok, area: area)
        .map((list) => list.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<SkpDetailBahanPokokEntity?> getDetailBahanPokok({required String slug, String tanggal = '', String area = ''}) {
    return local.watchDetailBahanPokok(slug: slug, tanggal: tanggal, area: area)
        .map((e) => e?.toEntity());
  }

  @override
  Future<void> syncAreas() async {
    try {
      final remoteData = await remote.fetchAreas();

      if (remoteData == null || remoteData.isEmpty) {
        return;
      }

      final isarData = remoteData.map((dto) => dto.toIsar()).toList();

      await local.saveAreas(isarData);
    } catch (e) {
      // Handle error, e.g., logging
    }
  }

  @override
  Future<void> syncBahanPokok({String tanggal = '', String bahanPokok = '', String area = ''}) async {
    try {
      final remoteData = await remote.fetchBahanPokok(tanggal: tanggal, bahanPokok: bahanPokok, area: area);

      if (remoteData == null || remoteData.isEmpty) {
        return;
      }

      final isarData = remoteData.map((dto) => dto.toIsar(qTanggal: tanggal, qBahanPokok: bahanPokok, qArea: area)).toList();

      await local.saveBahanPokok(isarData, tanggal: tanggal, bahanPokok: bahanPokok, area: area);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> syncDetailBahanPokok({required String slug, String tanggal = '', String area = ''}) async {
    try {
      final remoteData = await remote.fetchDetailBahanPokok(slug: slug, tanggal: tanggal, area: area);

      if (remoteData == null) {
        return;
      }

      final isarData = remoteData.toIsar(queryTanggal: tanggal, queryArea: area);

      await local.saveDetailBahanPokok(isarData);
    } catch (e) {
      // Handle error
    }
  }
}
