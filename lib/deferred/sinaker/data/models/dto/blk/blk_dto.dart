import 'package:freezed_annotation/freezed_annotation.dart';

part 'blk_dto.freezed.dart';
part 'blk_dto.g.dart';

/// Model for GET BLK list response
@freezed
@JsonSerializable(explicitToJson: true)
class BlkDto with _$BlkDto {
  const BlkDto({
    required this.id,
    this.nama,
    this.alamat,
    this.kabKota,
    this.kecamatan,
    this.slug,
    this.lat,
    this.lng,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "alamat")
  final String? alamat;

  @override
  @JsonKey(name: "kab_kota")
  final String? kabKota;

  @override
  @JsonKey(name: "kecamatan")
  final String? kecamatan;

  @override
  @JsonKey(name: "slug")
  final String? slug;

  @override
  @JsonKey(name: "lat")
  final double? lat;

  @override
  @JsonKey(name: "lng")
  final double? lng;

  // Json Serializable
  factory BlkDto.fromJson(Map<String, dynamic> json) =>
      _$BlkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BlkDtoToJson(this);
}
