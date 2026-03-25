import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// You might ask: Why use Notifier when Stateful can do it?
// It's due to the nature of the page using it that the state
// need to be read from another widget, therefore stateful, which
// is local-only, is not fitting

// ? Consumer Widget
class ChoiceChipWidget extends ConsumerWidget {
  final Map<int, String> choiceEntry;
  const ChoiceChipWidget({super.key, required this.choiceEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(choiceChipNotifierProvider);

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
              ref.read(choiceChipNotifierProvider.notifier).setTab(entry.key);
            },
          );
        }).toList(),
      ),
    );
  }
}

// ? Notifier Class
class ChoiceChipNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setTab(int choice) {
    state = choice;
  }

  void reset() {
    state = 0;
  }
}

// ? Notifier Provider
final choiceChipNotifierProvider = NotifierProvider.autoDispose<ChoiceChipNotifier, int>(() {
  return ChoiceChipNotifier();
});