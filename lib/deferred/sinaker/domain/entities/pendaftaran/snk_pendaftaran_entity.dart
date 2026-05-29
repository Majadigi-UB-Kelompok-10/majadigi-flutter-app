import 'package:freezed_annotation/freezed_annotation.dart';

part 'snk_pendaftaran_entity.freezed.dart';

/// Result from a successful pendaftaran POST
@freezed
class SnkPendaftaranResultEntity with _$SnkPendaftaranResultEntity {
  const SnkPendaftaranResultEntity({
    this.id,
    required this.status,
    required this.createdAt,
  });

  @override
  final int? id;

  @override
  final String status;

  @override
  final String createdAt;
}

/// A single status item from cek-status POST
@freezed
class SnkStatusPendaftaranEntity with _$SnkStatusPendaftaranEntity {
  const SnkStatusPendaftaranEntity({
    this.id,
    required this.blkNama,
    required this.blkSlug,
    required this.kejuruanNama,
    required this.status,
    required this.tanggalDaftar,
  });

  @override
  final int? id;

  @override
  final String blkNama;

  @override
  final String blkSlug;

  @override
  final String kejuruanNama;

  @override
  final String status;

  @override
  final String tanggalDaftar;
}
