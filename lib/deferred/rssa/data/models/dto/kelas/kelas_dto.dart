import 'package:freezed_annotation/freezed_annotation.dart';

part 'kelas_dto.freezed.dart';
part 'kelas_dto.g.dart';

/// Model for JSON to Kelas Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class KelasDto with _$KelasDto {
  const KelasDto({
    this.id,
    this.nama,
    this.slug,
  });

  @override
  @JsonKey(name: 'id')
  final int? id;

  @override
  @JsonKey(name: 'nama')
  final String? nama;

  @override
  @JsonKey(name: 'slug')
  final String? slug;

  // Json Serializable
  factory KelasDto.fromJson(Map<String, dynamic> json) =>
      _$KelasDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KelasDtoToJson(this);
}
