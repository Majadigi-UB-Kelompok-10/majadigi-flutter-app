import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/ui/sandbox/widgets/isar_restart_list_tile.dart';
import 'package:majadigi_mobile_rebuild/ui/sandbox/widgets/list_tiles.dart';

class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sandbox Testing"),
      ),
      body: Column(
        children: [
          IsarRestartListTile(),
          ListTiles()
        ],
      ),
    );
  }
}