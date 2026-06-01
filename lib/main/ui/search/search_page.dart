import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_header.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_searchbar.dart';
import 'package:majadigi_mobile_rebuild/main/ui/search/providers/search_query_provider.dart';
import 'package:majadigi_mobile_rebuild/main/ui/search/widgets/search_service_list.dart';

import '../dashboard/provider/navigation_index_provider.dart';
import '../dashboard/widgets/dashboard_bottom_navigation_bar.dart';

class SearchPage extends HookConsumerWidget {
  final String? query;
  const SearchPage({super.key, this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (query != null && query!.isNotEmpty) {
        Future.microtask(() {
          ref.read(searchQueryProvider.notifier).update(query!);
        });
      }
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              spacing: 12.0,
              children: [
                // Header
                DashboardHeader(useNavIndex: false),

                // Search Bar
                DashboardSearchbar(
                  initialValue: query,
                  onSearch: (String value) {
                    ref.read(searchQueryProvider.notifier).update(value);
                  },
                ),

                SizedBox(height: 10.0),

                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Hasil Pencarian \"${ref.watch(searchQueryProvider)}\"",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // Results of Search
                SearchServiceList(),
              ],
            ),
          ),
        )
      ),

      bottomNavigationBar: DashboardBottomNavigationBar(
        currentIndex: -1,
        onTap: (index) {
          // Set Index
          ref.read(navigationIndexProvider.notifier).setIndex(index);

          // Then send to dashboard
          context.go(
            Uri(
                path: '/homepage',
                queryParameters: { 'nav' : index.toString() }
            ).toString()
          );
        },
      ),
    );
  }
}