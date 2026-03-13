import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_cached_image.g.dart';

@JsonSerializable(explicitToJson: true)
class StacCachedImage extends StacWidget {
  const StacCachedImage({
    required this.imageUrl,
    this.height,
    this.width,
    this.useOldImageOnUrlChange = true,
  });

  final String imageUrl;
  final double? height;
  final double? width;

  @JsonKey(defaultValue: true)
  final bool useOldImageOnUrlChange;

  @override
  @JsonKey(includeToJson: true, includeFromJson: false)
  String get type => 'cachedImage';

  factory StacCachedImage.fromJson(Map<String, dynamic> json) => _$StacCachedImageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacCachedImageToJson(this);
}