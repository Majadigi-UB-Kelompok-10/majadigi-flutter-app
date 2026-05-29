import 'package:freezed_annotation/freezed_annotation.dart';

part 'pendaftaran_dto.freezed.dart';
part 'pendaftaran_dto.g.dart';

/// Model for POST pendaftaran response
@freezed
@JsonSerializable(explicitToJson: true)
class PendaftaranResultDto with _$PendaftaranResultDto {
  const PendaftaranResultDto({
    this.id,
    this.status,
    this.createdAt,
  });

  @override
  @JsonKey(name: "id")
  final int? id;

  @override
  @JsonKey(name: "status")
  final String? status;

  @override
  @JsonKey(name: "created_at")
  final String? createdAt;

  // Json Serializable
  factory PendaftaranResultDto.fromJson(Map<String, dynamic> json) =>
      _$PendaftaranResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PendaftaranResultDtoToJson(this);
}

/// Model for POST cek-status response items
@freezed
@JsonSerializable(explicitToJson: true)
class StatusPendaftaranDto with _$StatusPendaftaranDto {
  const StatusPendaftaranDto({
    this.id,
    this.blkNama,
    this.blkSlug,
    this.kejuruanNama,
    this.status,
    this.tanggalDaftar,
  });

  @override
  @JsonKey(name: "id")
  final int? id;

  @override
  @JsonKey(name: "blk_nama")
  final String? blkNama;

  @override
  @JsonKey(name: "blk_slug")
  final String? blkSlug;

  @override
  @JsonKey(name: "kejuruan_nama")
  final String? kejuruanNama;

  @override
  @JsonKey(name: "status")
  final String? status;

  @override
  @JsonKey(name: "tanggal_daftar")
  final String? tanggalDaftar;

  // Json Serializable
  factory StatusPendaftaranDto.fromJson(Map<String, dynamic> json) =>
      _$StatusPendaftaranDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatusPendaftaranDtoToJson(this);
}
