import 'package:majadigi_mobile_rebuild/main/domain/repositories/service_repository.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

/// SearchUseCase is responsible for searching for content using a search query.
class SearchServicesByQueryUseCase {
  final ServiceRepository repository;

  SearchServicesByQueryUseCase(this.repository);

  Future<List<ServiceEntity>> execute(String query) async {
    return await repository.searchServicesByQuery(query);
  }
}
