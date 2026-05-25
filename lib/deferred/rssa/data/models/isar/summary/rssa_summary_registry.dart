import 'package:isar_community/isar.dart';
import '../../../../domain/entities/summary/rssa_summary_entity.dart';

part 'rssa_summary_registry.g.dart';

@collection
class IsarRssaSummaryRegistry {
  Id id = 1; // Only ever one summary
  
  late int totalKapasitas;
  late int totalTersedia;

  @ignore
  RssaSummaryEntity toEntity() {
    return RssaSummaryEntity(
      totalKapasitas: totalKapasitas,
      totalTersedia: totalTersedia,
    );
  }
}
