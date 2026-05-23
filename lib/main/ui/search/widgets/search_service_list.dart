import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/core/credentials.dart';
import 'package:majadigi_mobile_rebuild/main/ui/search/providers/search_query_provider.dart';

class SearchServiceList extends ConsumerWidget {
  const SearchServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResult = ref.watch(searchServicesByQueryProvider(query));
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    return searchResult.when(
      error: (e, s) => Center(child: Text('Error: ${e.toString()}')),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (result) {
        if (result.isEmpty) {
          return const Center(child: Text('No services found'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: result.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final service = result[index];
            return ListTile(
              leading: service.iconUrl != null ?
              FractionallySizedBox(
                  widthFactor: 0.1,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: CachedNetworkImage(
                        imageUrl: service.iconUrl!,
                        fit: BoxFit.contain,
                        cacheManager: cacheManager,
                        useOldImageOnUrlChange: true,
                        errorWidget: (context, url, error) => const Icon(Icons.link),
                        placeholder: (context, idk) => const LinearProgressIndicator(),
                      )
                  )
              ) : const Icon(Icons.link),
              title: Text(
                service.title ?? '-',
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                service.description ?? '-',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              tileColor: const Color(0xFFE3F2FD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onTap: () => context.push(
                '/page-detail',
                extra: {
                  'serviceId': service.id,
                  'title': service.title,
                  'description': service.description
                }
              ),
            );
          },
        );
      }
    );
  }
}