import 'package:freezed_annotation/freezed_annotation.dart';

part 'jd_dokumen_detail_entity.freezed.dart';

/// Represents detailed information about a single JDIH document.
@freezed
class JdDokumenDetailEntity with _$JdDokumenDetailEntity {
  const JdDokumenDetailEntity({
    required this.id,
    this.jenis,
    this.nomor,
    this.tahun,
    this.judul,
    this.ringkasan,
    this.tanggalPenetapan,
    this.status,
    this.pdfUrl,
    this.pdfSizeKb,
    this.urusanPemerintahan,
    this.jumlahView,
    this.subjek,
  });

  @override
  final int id;

  @override
  final String? jenis;

  @override
  final String? nomor;

  @override
  final int? tahun;

  @override
  final String? judul;

  @override
  final String? ringkasan;

  @override
  final String? tanggalPenetapan;

  @override
  final String? status;

  @override
  final String? pdfUrl;

  @override
  final int? pdfSizeKb;

  @override
  final String? urusanPemerintahan;

  @override
  final int? jumlahView;

  @override
  final List<JdSubjekEntity>? subjek;
}

/// Represents a subjek (subject) tag on a document.
@freezed
class JdSubjekEntity with _$JdSubjekEntity {
  const JdSubjekEntity({
    required this.id,
    this.nama,
  });

  @override
  final int id;

  @override
  final String? nama;
}
