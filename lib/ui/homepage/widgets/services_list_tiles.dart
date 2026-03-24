import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/data/services/supabase/service_list/service_list_notifier.dart';
import 'package:majadigi_mobile/http.dart';

class ServicesListTiles extends ConsumerWidget {
  const ServicesListTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(serviceListProvider);

    return Expanded(
      child: asyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: $e', textAlign: TextAlign.center),
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return const Center(child: Text('No services found.'));
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];

              return ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: '$baseURL$imageURL${service.iconUrl ?? 'shared/skull.webp'}',
                          fit: BoxFit.contain,
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) => LinearProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                    ),
                  ),

                  title: Text(
                    service.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    service.description ?? 'No description available.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  onTap: () async {
                    Navigator.pushNamed(
                      context,
                      '/view',
                      arguments: <String, String>{
                        'id': service.id!,
                        'title': service.title!,
                        'description': service.description!,
                      },
                    );
                  }
              );
            },
          );
        },
      ),
    );
  }
}