import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'choice_chip_notifier.g.dart';

@riverpod
class ChoiceChipNotifier extends _$ChoiceChipNotifier {
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