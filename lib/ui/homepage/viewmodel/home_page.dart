import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';
import 'package:majadigi_mobile/cache.dart';
import 'package:majadigi_mobile/data/services/server_driven_ui_service.dart';

// * This page fetch page list to see all available SDUI
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(servicesFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SuperApp Services')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('Clear SDUI Network Cache'),
            subtitle: const Text('Wipes all offline JSON and API responses.'),
            onTap: () async {
              try {
                // 1. Read the store from Riverpod
                final store = await ref.read(cacheStoreProvider.future);

                // 2. Wipe the database and delete the physical files!
                await store.clean();

                // 3. Show a success message safely
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cache completely cleared!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to clear cache: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          Expanded(
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
                            imageUrl: '$baseURL$imageURL${service.icon ?? 'shared/skull.webp'}',
                            fit: BoxFit.contain,
                            useOldImageOnUrlChange: true,
                            placeholder: (context, url) => LinearProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                        ),
                      ),
                      title: Text(
                        service.title,
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
                          arguments: [
                            service.id,
                            service.title,
                            service.description
                          ],
                        );
                      }
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}