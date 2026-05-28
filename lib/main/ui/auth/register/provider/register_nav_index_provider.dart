import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_nav_index_provider.g.dart';

/// Navigation Index Provider to avoid Prop Drilling
@riverpod
class RegisterNavIndex extends _$RegisterNavIndex {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}