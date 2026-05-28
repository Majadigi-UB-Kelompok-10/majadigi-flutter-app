import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_dokumen_entity.freezed.dart';

/// Represents a document item from the JDIH dokumen-by-jenis endpoint.
@freezed
class JdDokumenEntity with _$JdDokumenEntity {
  const JdDokumenEntity({
    required this.id,
    this.jenis,
    this.judul,
    this.tanggal,
    this.status,
    this.pdfUrl,
  });

  @override
  final int id;

  @override
  final String? jenis;

  @override
  final String? judul;

  @override
  final String? tanggal;

  @override
  final String? status;

  @override
  final String? pdfUrl;
}
