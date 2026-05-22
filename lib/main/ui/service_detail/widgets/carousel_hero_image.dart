import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:majadigi_mobile_rebuild/main/core/credentials.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/image/image_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';

class CarouselHeroImage extends ConsumerWidget {
  final String serviceId;

  const CarouselHeroImage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamData = ref.watch(imageListProvider(serviceId));
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    return streamData.when(
        error: (e, s) => Center(child: Text('Error: $e', textAlign: TextAlign.center)),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (image) {
          return image.isNotEmpty ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CarouselView.weighted(
                  flexWeights: [1],
                  consumeMaxWeight: true,
                  scrollDirection: Axis.horizontal,
                  itemSnapping: true,
                  children: image.map((item) {
                    return Semantics(
                        label: item.semanticLabel ?? 'No Semantic',
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          fit: BoxFit.contain,
                          cacheManager: cacheManager,
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) => LinearProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                    );
                  }).toList()
              ),
            ),
          ) : SizedBox(
            height: 200,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: "",
              fit: BoxFit.fitWidth,
              cacheManager: cacheManager,
              useOldImageOnUrlChange: true,
              placeholder: (context, url) => LinearProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }
    );
  }
}