/*
 * What does this renderer do?
 * - Parse Map to List if key is index-based (1-...)
 * - Parse Map to Title and Subtitle if key-value is string
 * - Parse List to.. list (Rarely used)
 *
 * This renderer is recursive, and only used
 * for policy list widget in generic service page
 */


import 'package:flutter/material.dart';

class DynamicJsonToTextRenderer extends StatelessWidget {
  final dynamic data;
  final String? mapKey;
  const DynamicJsonToTextRenderer({super.key, required this.data, this.mapKey});

  @override
  Widget build(BuildContext context) {
    if (data is String) {
      return _StringRenderer(data: data as String, mapKey: mapKey);
    }

    else if (data is Map<String, dynamic>) {
      return _MapRenderer(data: data as Map<String, dynamic>, mapKey: mapKey);
    }

    else if (data is List<dynamic>) {
      return _ListRenderer(data: data as List<dynamic>, mapKey: mapKey);
    }

    // Fallback
    return const SizedBox.shrink();
  }
}

// ? If value is string, ends the recursive
class _StringRenderer extends StatelessWidget {
  final String data;
  final String? mapKey;
  const _StringRenderer({required this.data, this.mapKey});

  @override
  Widget build(BuildContext context) {
    bool isMapKeyExist = (mapKey != null);
    bool isNumeric = false;

    if (isMapKeyExist) {
      isNumeric = RegExp(r'^\d+$').hasMatch(mapKey!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        isMapKeyExist ? (isNumeric ? '$mapKey. $data' : '$mapKey: $data') : data,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

// ? If value is Map, render, then recursive
class _MapRenderer extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? mapKey;
  const _MapRenderer({required this.data, this.mapKey});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the key if we are inside another Map
          if (mapKey != null) Text(mapKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

          // Iterate through the map and recursively call this widget
          ...data.entries.map((entry) => DynamicJsonToTextRenderer(
            data: entry.value,
            mapKey: entry.key,
          ))
        ]
    );
  }
}

// ? If value is List, render, then recursive
class _ListRenderer extends StatelessWidget {
  final List<dynamic> data;
  final String? mapKey;
  const _ListRenderer({required this.data, this.mapKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mapKey != null) Text(mapKey!, style: const TextStyle(fontWeight: FontWeight.bold)),

        ...data.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key + 1}. ${entry.value}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        })
      ],
    );
  }
}