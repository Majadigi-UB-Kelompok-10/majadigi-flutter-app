import 'package:flutter/material.dart';
import 'package:majadigi_mobile/majadigi_mobile_icons.dart';
import 'package:url_launcher/link.dart';

class DynamicJsonViewer extends StatelessWidget {
  final String? originalKey;
  final dynamic data;
  final String? nodeKey; // Optional: keeps track of the key if it came from a Map

  const DynamicJsonViewer({super.key, this.originalKey, required this.data, this.nodeKey});

  @override
  Widget build(BuildContext context) {
    // BASE CASE: It's a string, so we display it.
    if (data is String) {
      if (data.startsWith('http')) {
        return Link(
            uri: Uri.parse(data),
            builder: (context, followLink) {
              return TextButton(
                onPressed: followLink,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  alignment: nodeKey != null ? Alignment.center : Alignment.centerLeft,
                  padding: EdgeInsets.all(0.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: nodeKey != null
                    ? (
                    switch (nodeKey?.toLowerCase()) {
                      "youtube" => Icon(Majadigi_Mobile.youtube, color: Colors.red, size: 30,),
                      "instagram" =>
                          ShaderMask(
                            blendMode: BlendMode.srcIn, // Ensures the gradient only colors the icon
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Majadigi_Mobile.instagram,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                    // Icon(Majadigi_Mobile.instagram, color: Colors.lightBlueAccent),
                      "facebook" => Icon(Majadigi_Mobile.facebook_squared, color: Colors.blue, size: 30,),
                      _ => Icon(Icons.error_outline)
                    }
                    )
                    : Text(data, style: const TextStyle(fontSize: 16)),
              );
            }
        );
      }

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
      print(map.entries.length);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the key if we are inside another Map
          if (nodeKey != null)
            Text(nodeKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

          // Iterate through the map and recursively call this widget
          if (originalKey?.contains('Media') == true || originalKey?.contains('Jam') == true) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loop through the map entries two at a time
                for (var i = 0; i < map.entries.length; i += (originalKey?.contains('Media') == true ? (map.entries.length) : 2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align both to top
                      children: [
                        // First Item in the Row
                        Expanded(
                          child: DynamicJsonViewer(
                            data: map.entries.elementAt(i).value,
                            nodeKey: map.entries.elementAt(i).key,
                          ),
                        ),

                        const SizedBox(width: 12), // Horizontal Gap

                        // Second Item (with a check to see if it exists)
                        Expanded(
                          child: i + 1 < map.entries.length
                              ? DynamicJsonViewer(
                            data: map.entries.elementAt(i + 1).value,
                            nodeKey: map.entries.elementAt(i + 1).key,
                          )
                              : const SizedBox.shrink(), // Empty space if odd count
                        ),

                        // Third or more item if it exists (only for Social Media)
                        if (originalKey?.contains('Media') == true) ...[
                          for (var j = 2; j < map.entries.length; j += 3) ...[
                            Expanded(
                              child: j < map.entries.length
                                  ? DynamicJsonViewer(
                                data: map.entries.elementAt(j).value,
                                nodeKey: map.entries.elementAt(j).key,
                              )
                                  : const SizedBox.shrink(), // Empty space if odd count
                            ),
                          ]
                        ]
                      ],
                    ),
                  ),
              ],
            )
          ] else ...[
            ...map.entries.map((entry) => DynamicJsonViewer(
              data: entry.value,
              nodeKey: entry.key,
            )),
          ]
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
                  '${entry.key + 1}. ${entry.value}',
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