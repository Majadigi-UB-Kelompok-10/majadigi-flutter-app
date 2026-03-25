import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/domain/sealed_type/tab_payload.dart';

import 'package:majadigi_mobile/ui/generic_service_page/widgets/choice_chip_notifier_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/integration_list_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/operational_list_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/policy_list_widget.dart';
import 'package:majadigi_mobile/domain/generic_service_domain/generic_service_page_data_middleware.dart';

class TabbedContentView extends ConsumerWidget {
  final String id;
  const TabbedContentView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(genericServicePageDataMiddlewareProvider(id));

    return asyncData.when(
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $e', textAlign: TextAlign.center),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (tabData) {
        if (tabData.isEmpty) {
          return const Center(
              child: Text('No Data A. Contact Administrator')
          );
        }

        // Map<int, Map<String, TabPayload>>

        // Prepare ChoiceChips
        final choiceEntry = <int, String>{};

        for (final entry in tabData.entries) {
          choiceEntry.putIfAbsent(entry.key, () => entry.value.keys.first);
        }

        // In case something went wrong
        if (choiceEntry.isEmpty) {
          return const Center(
              child: Text('No Data B. Contact Administrator')
          );
        }

        // Prepare List of TabPayloads
        final tabPayloads = <TabPayload>[];

        for (final entry in tabData.entries) {
          tabPayloads.add(entry.value.values.first);
        }

        // In case something went wrong AGAIN
        if (tabPayloads.isEmpty) {
          return const Center(
              child: Text('No Data C. Contact Administrator')
          );
        }

        return Column(
          children: [
            ChoiceChipWidget(choiceEntry: choiceEntry),
            SizedBox(height: 8.0),
            TabWidgetHelper(tabPayloads: tabPayloads),
          ],
        );
      }
    );
  }
}

class TabWidgetHelper extends ConsumerStatefulWidget {
  final List<TabPayload> tabPayloads;
  const TabWidgetHelper({super.key, required this.tabPayloads});

  @override
  ConsumerState<TabWidgetHelper> createState() => _TabWidgetHelperState();
}

class _TabWidgetHelperState extends ConsumerState<TabWidgetHelper> {
  @override
  Widget build(BuildContext context) {
    bool slideForward = true;

    ref.listen<int>(choiceChipNotifierProvider, (previous, next) {
      if (previous != null && previous != next) {
        setState(() {
          slideForward = next > previous;
        });
      }
    });

    final activeIndex = ref.watch(choiceChipNotifierProvider);

    Widget currentChild;
    if (activeIndex >= 0 && activeIndex < widget.tabPayloads.length) {
      // 1. Grab the specific payload for the active tab
      final currentPayload = widget.tabPayloads[activeIndex];

      // 2. Use the Dart 3 switch expression to map the payload to the correct Widget.
      // The compiler will force you to handle every possible subclass of TabPayload!
      final mappedWidget = switch (currentPayload) {
        IntegrationPayload(:final data) => IntegrationListWidget(data: data),
        OperationalPayload(:final data) => OperationalListWidget(data: data),
        PolicyPayload(:final data)      => PolicyListWidget(data: data),
      };

      // 3. Inject it into the KeyedSubtree
      currentChild = KeyedSubtree(
        key: ValueKey<int>(activeIndex),
        child: mappedWidget,
      );
    } else {
      currentChild = const SizedBox.shrink(key: ValueKey('empty'));
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ...previousChildren,
              ?currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideOffset = slideForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);

          final slideAnimation = Tween<Offset>(
            begin: slideOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ));

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
        child: currentChild,
      ),
    );
  }
}