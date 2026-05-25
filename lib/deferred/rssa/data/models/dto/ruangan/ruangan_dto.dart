import 'package:freezed_annotation/freezed_annotation.dart';

part 'ruangan_dto.freezed.dart';
part 'ruangan_dto.g.dart';

/// Model for JSON to Ruangan Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class RuanganDto with _$RuanganDto {
  const RuanganDto({
    required this.id,
    this.nama,
    this.slug,
    this.kelasNama,
    this.kelasSlug,
    this.kapasitas,
    this.terisi,
    this.tersedia
  });

  @override
  @JsonKey(name: 'id')
  final int id;

  @override
  @JsonKey(name: 'nama')
  final String? nama;

  @override
  @JsonKey(name: 'slug')
  final String? slug;

  @override
  @JsonKey(name: 'kelas_nama')
  final String? kelasNama;

  @override
  @JsonKey(name: 'kelas_slug')
  final String? kelasSlug;

  @override
  @JsonKey(name: 'kapasitas')
  final int? kapasitas;

  @override
  @JsonKey(name: 'terisi')
  final int? terisi;

  @override
  @JsonKey(name: 'tersedia')
  final int? tersedia;

  // Json Serializable
  factory RuanganDto.fromJson(Map<String, dynamic> json) =>
      _$RuanganDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RuanganDtoToJson(this);
}
