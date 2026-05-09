import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/home_page_header.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/home_page_searchbar.dart';

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
            HomePageHeader(),
            HomePageSearchbar(
              onSearch: (String value) {
                context.push(
                  Uri(
                    path: '/search',
                    queryParameters: { "q": value }
                  ).toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}