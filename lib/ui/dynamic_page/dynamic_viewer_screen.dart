import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stac/stac.dart';
import 'package:majadigi_mobile/data/services/server_driven_ui_service.dart';

class DynamicViewerScreen extends ConsumerWidget {
  final String pageLayoutName;

  const DynamicViewerScreen({super.key, required this.pageLayoutName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLayout = ref.watch(pageLayoutFutureProvider(pageLayoutName));

    return Scaffold(
      body: asyncLayout.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Failed to load UI: $e')),
        data: (json) {
          // Pass the successfully fetched JSON to Stac to build the UI
          return Stac.fromJson(json, context) ?? const Center(
            child: Text('Invalid Stac JSON'),
          );
        },
      ),
    );
  }
}