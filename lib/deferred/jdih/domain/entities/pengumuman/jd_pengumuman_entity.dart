import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_pengumuman_entity.freezed.dart';

/// Represents a JDIH announcement item.
@freezed
class JdPengumumanEntity with _$JdPengumumanEntity {
  const JdPengumumanEntity({
    required this.id,
    this.judul,
    this.isi,
    this.tanggal,
  });

  @override
  final int id;

  @override
  final String? judul;

  @override
  final String? isi;

  @override
  final String? tanggal;
}
