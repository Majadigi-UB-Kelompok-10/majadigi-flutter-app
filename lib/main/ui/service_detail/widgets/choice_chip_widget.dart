import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/service_detail/provider/choice_chip_notifier.dart';

class ChoiceChipWidget extends ConsumerWidget {
  final Map<int, String> choiceEntry;
  const ChoiceChipWidget({super.key, required this.choiceEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(choiceChipProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 8.0,
        children: choiceEntry.entries.map((entry) {
          return ChoiceChip(
            label: Text(entry.value),
            selected: activeTab == entry.key,
            showCheckmark: false,
            selectedColor: Colors.blueAccent.shade100.withValues(alpha: 0.5),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            side: BorderSide(
                width: 0.0,
                style: BorderStyle.none
            ),
            labelStyle: TextStyle(
              color: activeTab == entry.key ? Colors.blueAccent.shade700 : Colors.black87,
              fontWeight: activeTab == entry.key ? FontWeight.w500 : FontWeight.w300,
            ),
            onSelected: (selected) {
              ref.read(choiceChipProvider.notifier).setTab(entry.key);
            },
          );
        }).toList(),
      ),
    );
  }
}