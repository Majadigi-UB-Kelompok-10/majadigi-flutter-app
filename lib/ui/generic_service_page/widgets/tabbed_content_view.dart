import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi_mobile/domain/sealed_type/tab_payload.dart';

import 'package:majadigi_mobile/ui/generic_service_page/widgets/choice_chip_notifier_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/integration_list_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/operational_list_widget.dart';
import 'package:majadigi_mobile/ui/generic_service_page/widgets/tabs/policy_list_widget.dart';

class TabbedContentView extends ConsumerStatefulWidget {
  final List<TabPayload> tabPayloads;
  const TabbedContentView({super.key, required this.tabPayloads});

  @override
  ConsumerState<TabbedContentView> createState() => _TabbedContentViewState();
}

class _TabbedContentViewState extends ConsumerState<TabbedContentView> {
  bool _slideForward = true;

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(choiceChipNotifierProvider, (previous, next) {
      if (previous != null && previous != next) {
        setState(() {
          _slideForward = next > previous;
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
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideOffset = _slideForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);

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