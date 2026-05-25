import 'package:freezed_annotation/freezed_annotation.dart';

part 'rssa_summary_entity.freezed.dart';

@freezed
class RssaSummaryEntity with _$RssaSummaryEntity {
  const RssaSummaryEntity({
    required this.totalKapasitas,
    required this.totalTersedia,
  });

  @override
  final int totalKapasitas;

  @override
  final int totalTersedia;
}
