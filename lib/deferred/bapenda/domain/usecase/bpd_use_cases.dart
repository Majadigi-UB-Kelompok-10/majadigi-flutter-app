import '../entities/njkb/bpd_njkb_entity.dart';
import '../entities/pajak/bpd_pajak_entity.dart';
import '../repositories/bpd_repository.dart';

// ---------------------------------------------------------------------------
// Pajak Use Cases
// ---------------------------------------------------------------------------

class GetPajakInfoUseCase {
  final BpdRepository _repository;
  GetPajakInfoUseCase(this._repository);

  Future<BpdPajakEntity> execute({
    required String platNomor,
    required String nomorRangka,
  }) {
    return _repository.getPajakInfo(
      platNomor: platNomor,
      nomorRangka: nomorRangka,
    );
  }
}

// ---------------------------------------------------------------------------
// NJKB Cascading Option Use Cases
// ---------------------------------------------------------------------------

class GetJenisUseCase {
  final BpdRepository _repository;
  GetJenisUseCase(this._repository);

  Future<List<String>> execute() {
    return _repository.getJenis();
  }
}

class GetMerkUseCase {
  final BpdRepository _repository;
  GetMerkUseCase(this._repository);

  Future<List<String>> execute({required String jenis}) {
    return _repository.getMerk(jenis: jenis);
  }
}

class GetModelUseCase {
  final BpdRepository _repository;
  GetModelUseCase(this._repository);

  Future<List<String>> execute({
    required String jenis,
    required String merk,
  }) {
    return _repository.getModel(jenis: jenis, merk: merk);
  }
}

class GetTipeUseCase {
  final BpdRepository _repository;
  GetTipeUseCase(this._repository);

  Future<List<String>> execute({
    required String jenis,
    required String merk,
    required String model,
  }) {
    return _repository.getTipe(jenis: jenis, merk: merk, model: model);
  }
}

class GetTahunUseCase {
  final BpdRepository _repository;
  GetTahunUseCase(this._repository);

  Future<List<int>> execute({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
  }) {
    return _repository.getTahun(
      jenis: jenis,
      merk: merk,
      model: model,
      tipe: tipe,
    );
  }
}

// ---------------------------------------------------------------------------
// NJKB Kalkulasi Use Case
// ---------------------------------------------------------------------------

class PostKalkulasiUseCase {
  final BpdRepository _repository;
  PostKalkulasiUseCase(this._repository);

  Future<BpdNjkbKalkulasiEntity> execute({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  }) {
    return _repository.postKalkulasi(
      jenis: jenis,
      merk: merk,
      model: model,
      tipe: tipe,
      tahun: tahun,
    );
  }
}
