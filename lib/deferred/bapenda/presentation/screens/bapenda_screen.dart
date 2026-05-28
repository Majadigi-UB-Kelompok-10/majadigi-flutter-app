import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/bapenda_header.dart';
import 'bapenda_sell_screen.dart';
import 'bapenda_tax_screen.dart';

class BapendaScreen extends HookConsumerWidget {
  final int index;
  const BapendaScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: index);
    final activeTab = useState(index);

    Future<void> changePage(int index) async {
      if (index == activeTab.value) return;
      activeTab.value = index;
      await pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BapendaHeader(
            activeTab: activeTab.value,
            onTabChanged: changePage,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => activeTab.value = index,
                children: const [
                  BapendaTaxScreen(),
                  BapendaSellScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}