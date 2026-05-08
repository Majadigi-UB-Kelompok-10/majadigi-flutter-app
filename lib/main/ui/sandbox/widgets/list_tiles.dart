import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';

class ListTiles extends ConsumerWidget {
  const ListTiles({super.key});

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
              );
            },
          );
        },
      ),
    );
  }
}