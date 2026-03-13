import 'package:cached_network_image/cached_network_image.dart';
import 'package:stac/stac.dart';
import 'package:flutter/material.dart';

import 'package:majadigi_mobile/ui/stac/build_runner/stac_cached_image.dart';

class StacCachedImageParser extends StacParser<StacCachedImage> {
  const StacCachedImageParser();

  @override
  String get type => 'cachedImage';

  @override
  StacCachedImage getModel(Map<String, dynamic> json) =>
      StacCachedImage.fromJson(json);

  @override
  Widget parse(BuildContext context, StacCachedImage model) {
    return CachedNetworkImage(
      imageUrl: model.imageUrl,
      height: model.height,
      width: model.width,
      useOldImageOnUrlChange: model.useOldImageOnUrlChange,

      // You can even provide a global default for loaders here
      placeholder: (context, url) => const Center(
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2)
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
    );
  }
}