import '../entities/area/skp_area_entity.dart';
import '../entities/bahan_pokok/skp_bahan_pokok_entity.dart';
import '../entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';
import '../repositories/skp_repository.dart';

class GetSkpAreasUseCase {
  final SkpRepository repository;
  GetSkpAreasUseCase(this.repository);

  Stream<List<SkpAreaEntity>> call() {
    repository.syncAreas();
    return repository.getAreas();
  }
}

class GetSkpBahanPokokUseCase {
  final SkpRepository repository;
  GetSkpBahanPokokUseCase(this.repository);

  Stream<List<SkpBahanPokokEntity>> call({String tanggal = '', String bahanPokok = '', String area = ''}) {
    repository.syncBahanPokok(tanggal: tanggal, bahanPokok: bahanPokok, area: area);
    return repository.getBahanPokok(tanggal: tanggal, bahanPokok: bahanPokok, area: area);
  }
}

class GetSkpDetailBahanPokokUseCase {
  final SkpRepository repository;
  GetSkpDetailBahanPokokUseCase(this.repository);

  Stream<SkpDetailBahanPokokEntity?> call({required String slug, String tanggal = '', String area = ''}) {
    repository.syncDetailBahanPokok(slug: slug, tanggal: tanggal, area: area);
    return repository.getDetailBahanPokok(slug: slug, tanggal: tanggal, area: area);
  }
}
