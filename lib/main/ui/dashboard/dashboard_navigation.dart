import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/home_page.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/provider/navigation_index_provider.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_bottom_navigation_bar.dart';

/// Main Navigation Shell
class DashboardNavigation extends ConsumerWidget {
  const DashboardNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: navigationIndex,
          children: [
            HomePage(),
            const Center(child: Text('History')),
            const Center(child: Text('Profile')),
          ],
        ),
      ),

      bottomNavigationBar: DashboardBottomNavigationBar(
        currentIndex: navigationIndex,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).setIndex(index),
      ),
    );
  }
}