import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';

class IsarRestartListTile extends ConsumerWidget {
  const IsarRestartListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.folder_delete, color: Colors.red),
      title: const Text(
        'Wipe & Restart Isar',
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        ref.read(clearAndRestartIsarProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Isar database wiped and restarted'),
            ),
          );
        }
      }
    );
  }
}