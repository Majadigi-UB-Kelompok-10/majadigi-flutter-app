import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/mock/service_data.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_favorite.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_header.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/dashboard_searchbar.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/service_page_service_grid.dart';

class ServicePage extends HookWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditMode = useState(false);

    // Make local copy of service data
    final localServiceData = serviceData;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          children: [
            // Header
            DashboardHeader(),

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

            // Favorite Services Widget with Edit Toggle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardFavorite(
                    serviceList: localServiceData,
                    textButton: GestureDetector(
                      onTap: () => isEditMode.value = !isEditMode.value,
                      child: Text(isEditMode.value ? 'Selesai' : 'Edit', style: const TextStyle(color: Colors.blue, fontSize: 14)),
                    )
                ),
              ],
            ),
            
            // All Services Grid
            ServicePageServiceGrid(isEditMode: isEditMode.value)
          ],
        ),
      ),
    );
  }
}