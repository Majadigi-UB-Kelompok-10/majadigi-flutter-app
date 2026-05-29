import 'package:freezed_annotation/freezed_annotation.dart';

part 'wilayah_dto.freezed.dart';
part 'wilayah_dto.g.dart';

/// Shared model for all wilayah endpoints (provinsi, kab/kota, kecamatan, desa)
/// All have the same shape: id, nama, latitude, longitude
@freezed
@JsonSerializable(explicitToJson: true)
class WilayahDto with _$WilayahDto {
  const WilayahDto({
    required this.id,
    this.nama,
    this.latitude,
    this.longitude,
  });

  @override
  @JsonKey(name: "id")
  final String id;

  @override
  @JsonKey(name: "nama")
  final String? nama;

  @override
  @JsonKey(name: "latitude")
  final double? latitude;

  @override
  @JsonKey(name: "longitude")
  final double? longitude;

  // Json Serializable
  factory WilayahDto.fromJson(Map<String, dynamic> json) =>
      _$WilayahDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WilayahDtoToJson(this);
}
