import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service_detail/service_detail_provider.dart';
import 'package:majadigi_mobile_rebuild/main/domain/sealed/service_detail_aggregator_payload/service_detail_aggregator_payload.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/provider/choice_chip_notifier.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/choice_chip_widget.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/tabs/integration_list_widget.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/tabs/operational_list_widget.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/widgets/tabs/policy_list_widget.dart';

class TabbedContent extends ConsumerWidget {
  final String serviceId;
  const TabbedContent({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(serviceDetailPayloadProvider(serviceId));

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
        final tabPayloads = <ServiceDetailAggregatorPayload>[];

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

class TabWidgetHelper extends HookConsumerWidget {
  final List<ServiceDetailAggregatorPayload> tabPayloads;
  const TabWidgetHelper({super.key, required this.tabPayloads});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideForward = useState(true);

    ref.listen<int>(choiceChipProvider, (previous, next) {
      if (previous != null && previous != next) {
        slideForward.value = next > previous;
      }
    });

    final activeIndex = ref.watch(choiceChipProvider);

    Widget currentChild;
    if (activeIndex >= 0 && activeIndex < tabPayloads.length) {
      // 1. Grab the specific payload for the active tab
      final currentPayload = tabPayloads[activeIndex];

      // 2. Use the Dart 3 switch expression to map the payload to the correct Widget.
      // The compiler will force you to handle every possible subclass of TabPayload!
      final mappedWidget = switch (currentPayload) {
        IntegrationPayload(:final data) => IntegrationListWidget(data: data),
        OperationalPayload(:final data) => OperationalListWidget(data: List.of([data])),
        PolicyPayload(:final data)      => PolicyListWidget(data: List.of([data])),
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
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideOffset = slideForward.value ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);

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