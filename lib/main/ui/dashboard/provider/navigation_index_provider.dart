import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_index_provider.g.dart';

/// Navigation Index Provider to avoid Prop Drilling
@Riverpod(keepAlive: true)
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}