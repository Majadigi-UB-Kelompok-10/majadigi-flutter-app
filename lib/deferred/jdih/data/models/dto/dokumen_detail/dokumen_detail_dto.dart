import 'package:freezed_annotation/freezed_annotation.dart';

part 'dokumen_detail_dto.freezed.dart';
part 'dokumen_detail_dto.g.dart';

/// DTO for the GET /jdih/public/dokumen/detail/{id} endpoint.
@freezed
@JsonSerializable(explicitToJson: true)
class DokumenDetailDto with _$DokumenDetailDto {
  const DokumenDetailDto({
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
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "jenis")
  final String? jenis;

  @override
  @JsonKey(name: "nomor")
  final String? nomor;

  @override
  @JsonKey(name: "tahun")
  final int? tahun;

  @override
  @JsonKey(name: "judul")
  final String? judul;

  @override
  @JsonKey(name: "ringkasan")
  final String? ringkasan;

  @override
  @JsonKey(name: "tanggal_penetapan")
  final String? tanggalPenetapan;

  @override
  @JsonKey(name: "status")
  final String? status;

  @override
  @JsonKey(name: "pdf_url")
  final String? pdfUrl;

  @override
  @JsonKey(name: "pdf_size_kb")
  final int? pdfSizeKb;

  @override
  @JsonKey(name: "urusan_pemerintahan")
  final String? urusanPemerintahan;

  @override
  @JsonKey(name: "jumlah_view")
  final int? jumlahView;

  @override
  @JsonKey(name: "subjek")
  final List<SubjekDto>? subjek;

  factory DokumenDetailDto.fromJson(Map<String, dynamic> json) =>
      _$DokumenDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DokumenDetailDtoToJson(this);
}

/// Nested DTO for subjek items within DokumenDetailDto.
@freezed
@JsonSerializable(explicitToJson: true)
class SubjekDto with _$SubjekDto {
  const SubjekDto({
    required this.id,
    this.nama,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  factory SubjekDto.fromJson(Map<String, dynamic> json) =>
      _$SubjekDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubjekDtoToJson(this);
}
