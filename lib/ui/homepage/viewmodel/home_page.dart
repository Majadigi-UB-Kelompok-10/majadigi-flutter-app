import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:majadigi_mobile/cache.dart';
import 'package:majadigi_mobile/data/services/server_driven_ui_service.dart';

class DynamicJsonViewer extends StatelessWidget {
  final dynamic data;
  final String? nodeKey; // Optional: keeps track of the key if it came from a Map

  const DynamicJsonViewer({super.key, required this.data, this.nodeKey});

  @override
  Widget build(BuildContext context) {
    // BASE CASE: It's a string, so we display it.
    if (data is String) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          nodeKey != null ? '$nodeKey: $data' : data,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // RECURSIVE CASE 1: It's a JSON Object (Map)
    else if (data is Map<String, dynamic>) {
      final map = data as Map<String, dynamic>;
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the key if we are inside another Map
            if (nodeKey != null)
              Text(nodeKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

            // Iterate through the map and recursively call this widget
            ...map.entries.map((entry) => DynamicJsonViewer(
              data: entry.value,
              nodeKey: entry.key,
            )),
          ],
        ),
      );
    }

    // RECURSIVE CASE 2: It's a JSON Array (List)
    else if (data is List<dynamic>) {
      final list = data as List<dynamic>;
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (nodeKey != null)
              Text(nodeKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

            // Iterate through the list and recursively call this widget
            // (Lists don't have keys, so we pass null for the nodeKey)
            ...list.map((item) => DynamicJsonViewer(data: item)),
          ],
        ),
      );
    }

    // Fallback just in case a rogue null or int slips through
    return const SizedBox.shrink();
  }
}

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
          // Expanded(
          //   child: FutureBuilder(
          //     future: Supabase.instance.client.from('services_list').select(),
          //     builder: (context, snapshot) {
          //       // 2. Handle the loading state
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //
          //       // 3. Handle any errors
          //       if (snapshot.hasError) {
          //         return Center(child: Text('Error: ${snapshot.error}'));
          //       }
          //
          //       final services = snapshot.data;
          //
          //       // 4. Handle empty data
          //       if (services == null || services.isEmpty) {
          //         return const Center(child: Text('No services found.'));
          //       }
          //
          //       // 5. Build the list of services
          //       return ListView.builder(
          //         itemCount: services.length,
          //         itemBuilder: (context, index) {
          //           final service = services[index];
          //
          //           // Extract the fields from the Map
          //           final icon = service['icon'] as String?;
          //           final title = service['title'] as String?;
          //           final description = service['description'] as String?;
          //
          //           // This is your jsonb data. It remains dynamic so our viewer can parse it.
          //           final additionalData = service['additional_data'];
          //
          //           return Card(
          //             margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //             child: Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   SizedBox(
          //                     height: 100,
          //                     child: CachedNetworkImage(
          //                       imageUrl: '$baseURL$imageURL$icon',
          //                       fit: BoxFit.contain,
          //                       useOldImageOnUrlChange: true,
          //                       placeholder: (context, url) => LinearProgressIndicator(),
          //                       errorWidget: (context, url, error) => Icon(Icons.error),
          //                     ),
          //                   ),
          //                   const SizedBox(height: 16),
          //                   Text(
          //                     title ?? 'Unknown Service',
          //                     style: const TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                   const SizedBox(height: 8),
          //                   Text(
          //                     description ?? 'No description available.',
          //                     style: const TextStyle(fontSize: 14, color: Colors.grey),
          //                   ),
          //                   const Divider(height: 24),
          //                   const Text(
          //                     'Additional Data:',
          //                     style: TextStyle(fontWeight: FontWeight.w600),
          //                   ),
          //                   const SizedBox(height: 8),
          //
          //                   // Pass the raw jsonb directly into the recursive widget
          //                   DynamicJsonViewer(data: additionalData),
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }
          //   ),
          // ),
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

                    return ExpansionTile(
                      title: Text(service.title),
                      subtitle: Text(service.description ?? ''),
                      children: [
                        const Text("Policies:"),
                        DynamicJsonViewer(data: service.additionalData.policies),

                        const Text("Services:"),
                        DynamicJsonViewer(data: service.additionalData.services),

                        const Text("Operationals:"),
                        DynamicJsonViewer(data: service.additionalData.operationals),
                      ],
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