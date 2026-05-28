import 'package:freezed_annotation/freezed_annotation.dart';

part 'pengumuman_dto.freezed.dart';
part 'pengumuman_dto.g.dart';

/// DTO for the GET /jdih/public/pengumuman endpoint items.
@freezed
@JsonSerializable(explicitToJson: true)
class PengumumanDto with _$PengumumanDto {
  const PengumumanDto({
    required this.id,
    this.judul,
    this.isi,
    this.tanggal,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "judul")
  final String? judul;

  @override
  @JsonKey(name: "isi")
  final String? isi;

  @override
  @JsonKey(name: "tanggal")
  final String? tanggal;

  factory PengumumanDto.fromJson(Map<String, dynamic> json) =>
      _$PengumumanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PengumumanDtoToJson(this);
}
