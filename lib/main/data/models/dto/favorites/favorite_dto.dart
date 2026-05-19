import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part 'favorite_dto.freezed.dart';
part 'favorite_dto.g.dart';

/// Model for JSON to Favorite Entity Object, does not resolve to ISAR object
@freezed
@JsonSerializable(explicitToJson: true)
class FavoriteDto with _$FavoriteDto {
  const FavoriteDto({
    this.favorites,
    this.updatedAt
  });

  @override
  @JsonKey(name: 'favorites')
  final List<Map<String, String>>? favorites;

  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  // Json Serializable
  factory FavoriteDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteDtoToJson(this);

  @ignore
  List<String>? get serviceIds => favorites?.map((serviceMap) => serviceMap["service_id"]!).toList();
}
