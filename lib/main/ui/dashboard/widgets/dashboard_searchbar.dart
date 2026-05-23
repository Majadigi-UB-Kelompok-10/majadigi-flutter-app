import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Search Bar Widget for Home Page
class DashboardSearchbar extends HookConsumerWidget {
  final String? initialValue;
  final ValueChanged<String>? onSearch;
  const DashboardSearchbar({super.key, this.onSearch, this.initialValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: initialValue ?? "");

    // Handle Search
    void executeSearch() {
      if (onSearch != null && searchController.text.isNotEmpty) {
        onSearch!.call(searchController.text);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) => executeSearch(),
        decoration: InputDecoration(
          hintText: 'Cari Layanan',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 18.0,
          ),
          suffixIcon: GestureDetector(
            onTap: () => executeSearch(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.search,
                color: Colors.grey.shade500,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}