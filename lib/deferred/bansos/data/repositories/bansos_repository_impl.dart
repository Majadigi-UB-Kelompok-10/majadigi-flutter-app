import '../../domain/entities/bansos/bansos_entity.dart';
import '../../domain/repositories/bansos_repository.dart';
import '../datasources/bansos_local_datasource.dart';
import '../datasources/bansos_remote_datasource.dart';
import '../models/dto/bansos_dto.dart';
import '../models/isar/bansos/bansos_registry.dart';
import '../../../../main/data/models/isar/fast_hash.dart';

extension BansosDtoToIsar on BansosDto {
  IsarBansosRegistry toIsar() {
    return IsarBansosRegistry()
      ..id = fastHash(profil.nik)
      ..nik = profil.nik
      ..nama = profil.nama
      ..alamat = profil.alamat
      ..riwayat = riwayat.map((r) => IsarRiwayat()
        ..penyaluranId = r.penyaluranId
        ..programNama = r.programNama
        ..periode = r.periode
        ..nominal = r.nominal
        ..status = r.status
      ).toList();
  }
}

class BansosRepositoryImpl implements BansosRepository {
  final BansosLocalDatasource localDatasource;
  final BansosRemoteDatasource remoteDatasource;

  BansosRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<BansosEntity?> getBansosByNik(String nik) async {
    // WAIT for sync to ensure data exist
    await syncBansosByNik(nik);

    final cached = await localDatasource.getCachedBansosByNik(nik);
    return cached?.toEntity();
  }

  @override
  Future<void> syncBansosByNik(String nik) async {
    try {
      final remoteData = await remoteDatasource.fetchBansosByNik(nik);
      if (remoteData != null) {
        await localDatasource.cacheBansos(remoteData.toIsar());
      }
    } catch (e) {
      // Ignored for background sync
    }
  }

  @override
  Stream<List<BansosEntity>> watchBansosByNik(String nik) {
    // Can fire and forget
    syncBansosByNik(nik);

    return localDatasource.watchCachedBansosByNik(nik).map((bansos) {
      return bansos.map((bansos) => bansos.toEntity()).toList();
    });
  }
}
