import 'package:freezed_annotation/freezed_annotation.dart';

part 'dokumen_dto.freezed.dart';
part 'dokumen_dto.g.dart';

/// DTO for items in the GET /jdih/public/dokumen/{jenis} endpoint.
@freezed
@JsonSerializable(explicitToJson: true)
class DokumenDto with _$DokumenDto {
  const DokumenDto({
    required this.id,
    this.jenis,
    this.judul,
    this.tanggal,
    this.status,
    this.pdfUrl,
  });

  @override
  @JsonKey(name: "id")
  final int id;

  @override
  @JsonKey(name: "jenis")
  final String? jenis;

  @override
  @JsonKey(name: "judul")
  final String? judul;

  @override
  @JsonKey(name: "tanggal")
  final String? tanggal;

  @override
  @JsonKey(name: "status")
  final String? status;

  @override
  @JsonKey(name: "pdf_url")
  final String? pdfUrl;

  factory DokumenDto.fromJson(Map<String, dynamic> json) =>
      _$DokumenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DokumenDtoToJson(this);
}
