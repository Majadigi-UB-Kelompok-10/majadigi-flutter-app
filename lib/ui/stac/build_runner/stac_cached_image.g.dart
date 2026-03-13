// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_cached_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StacCachedImage _$StacCachedImageFromJson(Map<String, dynamic> json) =>
    StacCachedImage(
      imageUrl: json['imageUrl'] as String,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      useOldImageOnUrlChange: json['useOldImageOnUrlChange'] as bool? ?? true,
    );

Map<String, dynamic> _$StacCachedImageToJson(StacCachedImage instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'height': instance.height,
      'width': instance.width,
      'useOldImageOnUrlChange': instance.useOldImageOnUrlChange,
      'type': instance.type,
    };
