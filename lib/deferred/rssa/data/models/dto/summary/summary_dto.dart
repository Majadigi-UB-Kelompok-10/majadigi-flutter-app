import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary_dto.freezed.dart';
part 'summary_dto.g.dart';

/// Model for JSON to Summary Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class SummaryDto with _$SummaryDto {
  const SummaryDto({
    this.totalKapasitas,
    this.totalTersedia,
  });

  @override
  @JsonKey(name: 'total_kapasitas')
  final int? totalKapasitas;

  @override
  @JsonKey(name: 'total_tersedia')
  final int? totalTersedia;

  // Json Serializable
  factory SummaryDto.fromJson(Map<String, dynamic> json) =>
      _$SummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryDtoToJson(this);
}
