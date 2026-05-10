import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/integration/integration_entity.dart';

class IntegrationListWidget extends ConsumerWidget {
  final List<IntegrationEntity> data;
  const IntegrationListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(height: 12.0),
        itemBuilder: (context, index) {
          final entry = data[index];

          return ListTile(
            leading: entry.iconUrl != null ?
            FractionallySizedBox(
                widthFactor: 0.1,
                child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: CachedNetworkImage(
                      imageUrl: entry.iconUrl!,
                      fit: BoxFit.contain,
                      cacheManager: cacheManager,
                      useOldImageOnUrlChange: true,
                      errorWidget: (context, url, error) => const Icon(Icons.link),
                      placeholder: (context, idk) => const LinearProgressIndicator(),
                    )
                )
            )
                : const Icon(Icons.link),
            title: Text(
                entry.title!,
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.blue.shade900)
            ),
            tileColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onTap: () async {
              // None
            },
          );
        },
      ),
    );
  }
}