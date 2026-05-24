// Check [ENDPOINT.md](./ENDPOINT.md) on why this dto modeled like this

// For Isar model later, use NIK combined with fast hash from fast_hash.dart
// inside main package under lib/main/data/models/isar/fast_hash.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bansos_dto.freezed.dart';
part 'bansos_dto.g.dart';

/// Model for JSON to Bansos Entity Object
@freezed
@JsonSerializable(explicitToJson: true)
class BansosDto with _$BansosDto {
  const BansosDto({
    required this.profil,
    required this.riwayat
  });

  @override
  @JsonKey(name: "profil")
  final ProfilDto profil;

  @override
  @JsonKey(name: "riwayat")
  final List<RiwayatDto> riwayat;

  // Json Serializable
  factory BansosDto.fromJson(Map<String, dynamic> json) =>
      _$BansosDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BansosDtoToJson(this);
}

/// Model for JSON to Profil
@freezed
@JsonSerializable(explicitToJson: true)
class ProfilDto with _$ProfilDto {
  const ProfilDto({
    required this.nama,
    required this.alamat,
    required this.nik,
  });

  @override
  @JsonKey(name: "nama")
  final String nama;

  @override
  @JsonKey(name: "alamat")
  final String alamat;

  @override
  @JsonKey(name: "nik")
  final String nik;

  factory ProfilDto.fromJson(Map<String, dynamic> json) =>
      _$ProfilDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilDtoToJson(this);
}

/// Model for JSON to Riwayat
@freezed
@JsonSerializable(explicitToJson: true)
class RiwayatDto with _$RiwayatDto {
  const RiwayatDto({
    required this.penyaluranId,
    required this.programNama,
    required this.periode,
    required this.nominal,
    required this.status,
  });

  @override
  @JsonKey(name: 'penyaluran_id')
  final int penyaluranId;

  @override
  @JsonKey(name: 'program_nama')
  final String programNama;

  @override
  @JsonKey(name: "periode")
  final String periode;

  @override
  @JsonKey(name: "nominal")
  final String nominal;

  @override
  @JsonKey(name: "status")
  final String status;


  factory RiwayatDto.fromJson(Map<String, dynamic> json) =>
      _$RiwayatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RiwayatDtoToJson(this);
}
