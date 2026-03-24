import 'package:flutter/material.dart';
import 'package:majadigi_mobile/ui/homepage/widgets/cache_wipe_list_tile.dart';
import 'package:majadigi_mobile/ui/homepage/widgets/services_list_tiles.dart';

// * This page fetch page list to see all available SDUI
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SuperApp Services')),
      body: Column(
        children: [
          WipeCacheListTile(),
          Divider(),
          ServicesListTiles()
        ],
      ),
    );
  }
}