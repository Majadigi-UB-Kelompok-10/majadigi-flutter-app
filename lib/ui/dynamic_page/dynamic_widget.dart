import 'package:flutter/material.dart';

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
      return Column(
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
      );
    }

    // RECURSIVE CASE 2: It's a JSON Array (List)
    else if (data is List<dynamic>) {
      final list = data as List<dynamic>;
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (nodeKey != null)
              Text(nodeKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

            // Iterate through the list and recursively call this widget
            // (Lists don't have keys, so we pass null for the nodeKey)
            // ...list.map((item) => DynamicJsonViewer(data: item)),
            ...list.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${entry.key + 1}: ${entry.value}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            })
          ],
        ),
      );
    }

    // Fallback just in case a rogue null or int slips through
    return const SizedBox.shrink();
  }
}