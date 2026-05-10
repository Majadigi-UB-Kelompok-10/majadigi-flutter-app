import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/mock/news_data.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/mock/statistic_data.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_favorite.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_header.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_searchbar.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/home_page_news.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/home_page_statistic.dart';

/// Home Page View
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DashboardHeader(useNavIndex: true),

            // Search Bar
            DashboardSearchbar(
              onSearch: (String value) {
                context.push(
                  Uri(
                    path: '/search',
                    queryParameters: { "q": value }
                  ).toString(),
                );
              },
            ),

            // Favorites
            DashboardFavorite(),

            // Statistics
            HomePageStatistic(statisticList: statisticData),

            // News
            HomePageNews(newsList: newsData, onSeeAll: () => ())
          ],
        ),
      ),
    );
  }
}