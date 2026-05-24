import 'package:freezed_annotation/freezed_annotation.dart';

part 'bansos_entity.freezed.dart';

@freezed
class BansosEntity with _$BansosEntity {
  const BansosEntity({
    required this.profil,
    required this.riwayat,
  });

  @override
  final ProfilEntity profil;

  @override
  final List<RiwayatEntity> riwayat;
}

@freezed
class ProfilEntity with _$ProfilEntity {
  const ProfilEntity({
    required this.nama,
    required this.alamat,
    required this.nik,
  });

  @override
  final String nama;

  @override
  final String alamat;

  @override
  final String nik;
}

@freezed
class RiwayatEntity with _$RiwayatEntity {
  const RiwayatEntity({
    required this.penyaluranId,
    required this.programNama,
    required this.periode,
    required this.nominal,
    required this.status,
  });

  @override
  final int penyaluranId;

  @override
  final String programNama;

  @override
  final String periode;

  @override
  final String nominal;

  @override
  final String status;
}
