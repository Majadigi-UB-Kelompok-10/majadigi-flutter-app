import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/server_driven_ui_service_dio.dart';
import 'package:majadigi_mobile/http.dart';

// * This page fetch page list to see all available SDUI
/* The JSON Format is as below:
 * [
 *    {
 *      "title": "<service>",
 *      "pageLayouts": {
 *        "<page name>": "<page_url.json>",
 *        ...
 *      },
 *      "description": "<desc>"
 *      "images": ["<image.webp>", ...]
 *    },
 *    {
 *      "title": "<service>",
 *      "pageLayouts": {
 *        "<page name>": "<page_url.json>",
 *        ...
 *      },
 *      "description": "<desc>"
 *      "images": ["<image.webp>", ...]
 *    },
 *    ...
 * ]
 */
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(pageListFutureProvider);

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
              data: (list) => ListView(
                children: list.map((pageItem) => ListTile(
                  leading: const Icon(Icons.extension),
                  title: Text(pageItem.title),
                  onTap: () => Navigator.pushNamed(context, '/view', arguments: [pageItem.title, pageItem.pageLayouts, pageItem.description, pageItem.images]),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}