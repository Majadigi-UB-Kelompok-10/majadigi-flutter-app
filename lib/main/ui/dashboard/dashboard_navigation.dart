import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/home_page.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/provider/navigation_index_provider.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/service_page.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_bottom_navigation_bar.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/profile_page.dart';

/// Main Navigation Shell
class DashboardNavigation extends HookConsumerWidget {
  final int initialIndex;
  const DashboardNavigation({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationIndex = ref.watch(navigationIndexProvider);

    useEffect(() {
      Future<void> setNavIndex() async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(navigationIndexProvider.notifier).setIndex(initialIndex);
          }
        });
      }

      setNavIndex();

      // Cleanup
      return () {};
    }, [initialIndex]);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: navigationIndex,
          children: [
            const HomePage(),
            const ServicePage(),
            const ProfilePage(),
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