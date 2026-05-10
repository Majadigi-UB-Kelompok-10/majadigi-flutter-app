import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/core/http.dart' show supabaseBaseUrl, supabaseImageUrl;
import 'package:majadigi_mobile_rebuild/main/ui/search/providers/search_query_provider.dart';

class SearchServiceList extends ConsumerWidget {
  const SearchServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final searchResult = ref.watch(searchServicesByQueryProvider(query));
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    return searchResult.when(
      error: (e, s) => SizedBox.shrink(),
      loading: () => SizedBox.shrink(),
      data: (result) {
        if (result.isEmpty) {
          return SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: result.length,
          itemBuilder: (context, index) {
            final service = result[index];
            return ListTile(
              leading: service.iconUrl != null ?
              FractionallySizedBox(
                  widthFactor: 0.1,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: CachedNetworkImage(
                        imageUrl: '$supabaseBaseUrl$supabaseImageUrl${service.iconUrl!}',
                        fit: BoxFit.contain,
                        cacheManager: cacheManager,
                        useOldImageOnUrlChange: true,
                        errorWidget: (context, url, error) => const Icon(Icons.link),
                        placeholder: (context, idk) => const LinearProgressIndicator(),
                      )
                  )
              ) : const Icon(Icons.link),
              title: Text(
                service.title!,
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                service.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              tileColor: Colors.grey.shade100,
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