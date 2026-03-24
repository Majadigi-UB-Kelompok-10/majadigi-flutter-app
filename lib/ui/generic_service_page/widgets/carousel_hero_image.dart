import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:majadigi_mobile/data/services/supabase/image_list/image_list_notifier.dart';
import 'package:majadigi_mobile/http.dart';

class CarouselHeroImage extends ConsumerWidget {
  final String serviceListId;

  const CarouselHeroImage({super.key, required this.serviceListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(imageListProvider(serviceListId));

    return asyncData.when(
        error: (e, s) => Center(child: Text('Error: $e', textAlign: TextAlign.center)),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (imageList) {
          return imageList.isNotEmpty ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CarouselView.weighted(
                  flexWeights: [1],
                  consumeMaxWeight: true,
                  scrollDirection: Axis.horizontal,
                  itemSnapping: true,
                  children: imageList.map((item) {
                    return Semantics(
                      label: item.semanticLabel ?? 'No Semantic',
                      child: CachedNetworkImage(
                        imageUrl: '$baseURL$imageURL${item.imageUrl}',
                        fit: BoxFit.contain,
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
              imageUrl: '$baseURL${imageURL}shared/skull.webp',
              fit: BoxFit.fitWidth,
              useOldImageOnUrlChange: true,
              placeholder: (context, url) => LinearProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }
    );
  }
}