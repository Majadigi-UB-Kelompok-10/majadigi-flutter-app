import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:majadigi_mobile/cache.dart';
import 'package:majadigi_mobile/http.dart';

class WipeCacheListTile extends ConsumerWidget {
  const WipeCacheListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.delete_sweep, color: Colors.red),
      title: const Text('Clear SDUI Network Cache'),
      subtitle: const Text('Wipes all offline JSON and API responses.'),
      onTap: () async {
        try {
          // 1. Read the store from Riverpod
          final store = await ref.read(cacheStoreProvider.future);
          final dioStore = await ref.read(dioCacheStoreProvider.future);

          // 2. Wipe the database and delete the physical files!
          await store.clean();
          await dioStore.clean();

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
    );
  }
}