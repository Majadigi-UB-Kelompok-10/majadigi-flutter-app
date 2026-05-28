import 'package:majadigi_mobile_rebuild/deferred/bapenda/data/datasources/bpd_remote_datasource.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/data/models/dto/njkb/njkb_kalkulasi_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/data/models/dto/pajak/pajak_info_dto.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/domain/entities/njkb/bpd_njkb_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/domain/entities/pajak/bpd_pajak_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/domain/repositories/bpd_repository.dart';

// ---------------------------------------------------------------------------
// DTO → Entity Mapping Extensions
// ---------------------------------------------------------------------------

extension PajakInfoDtoToEntity on PajakInfoDto {
  BpdPajakEntity toEntity() {
    return BpdPajakEntity(
      identitas: BpdPajakIdentitasEntity(
        platNomor: identitas.platNomor,
        merk: identitas.merk,
        tipe: identitas.tipe,
        model: identitas.model,
        warna: identitas.warna,
        tahunBuat: identitas.tahunBuat,
        masaPajak: identitas.masaPajak,
        statusAktif: identitas.statusAktif,
      ),
      rincianBiaya: BpdPajakRincianBiayaEntity(
        pkbPokok: rincianBiaya.pkbPokok,
        opsenPkb: rincianBiaya.opsenPkb,
        swdkllj: rincianBiaya.swdkllj,
        parkirBerlangganan: rincianBiaya.parkirBerlangganan,
        totalPajak: rincianBiaya.totalPajak,
      ),
      estimasi5Tahunan: BpdPajakEstimasi5TahunanEntity(
        cetakStnk: estimasi5Tahunan.cetakStnk,
        cetakTnkb: estimasi5Tahunan.cetakTnkb,
      ),
    );
  }
}

extension NjkbKalkulasiDtoToEntity on NjkbKalkulasiDto {
  BpdNjkbKalkulasiEntity toEntity() {
    return BpdNjkbKalkulasiEntity(
      njkb: njkb,
      estimasi: estimasi
          .map((e) => BpdNjkbEstimasiEntity(
                jenisPlat: e.jenisPlat,
                label: e.label,
                pkb: e.pkb,
                opsen: e.opsen,
              ))
          .toList(),
      beaBalikNama: BpdNjkbBeaBalikNamaEntity(
        bbn1: beaBalikNama.bbn1,
        opsenBbn1: beaBalikNama.opsenBbn1,
        bbn2: beaBalikNama.bbn2,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Repository Implementation
// ---------------------------------------------------------------------------

class BpdRepositoryImpl implements BpdRepository {
  final BpdRemoteDatasource _remoteDatasource;

  BpdRepositoryImpl({required BpdRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<BpdPajakEntity> getPajakInfo({
    required String platNomor,
    required String nomorRangka,
  }) async {
    final dto = await _remoteDatasource.fetchPajakInfo(
      platNomor: platNomor,
      nomorRangka: nomorRangka,
    );
    return dto.toEntity();
  }

  @override
  Future<List<String>> getJenis() {
    return _remoteDatasource.fetchJenis();
  }

  @override
  Future<List<String>> getMerk({required String jenis}) {
    return _remoteDatasource.fetchMerk(jenis: jenis);
  }

  @override
  Future<List<String>> getModel({
    required String jenis,
    required String merk,
  }) {
    return _remoteDatasource.fetchModel(jenis: jenis, merk: merk);
  }

  @override
  Future<List<String>> getTipe({
    required String jenis,
    required String merk,
    required String model,
  }) {
    return _remoteDatasource.fetchTipe(jenis: jenis, merk: merk, model: model);
  }

  @override
  Future<List<int>> getTahun({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
  }) {
    return _remoteDatasource.fetchTahun(
      jenis: jenis,
      merk: merk,
      model: model,
      tipe: tipe,
    );
  }

  @override
  Future<BpdNjkbKalkulasiEntity> postKalkulasi({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  }) async {
    final dto = await _remoteDatasource.fetchKalkulasi(
      jenis: jenis,
      merk: merk,
      model: model,
      tipe: tipe,
      tahun: tahun,
    );
    return dto.toEntity();
  }
}
