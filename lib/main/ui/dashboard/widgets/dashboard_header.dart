import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/provider/navigation_index_provider.dart';

/// Top Header for Home Page
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar
        GestureDetector(
          onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(2),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0652C5),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        
        // Logo
        Image.asset(
          'assets/majadigi-main-logo-with-text.png',
          width: MediaQuery.of(context).size.width * 0.4,
          fit: BoxFit.contain,
        ),
        
        // Notification Button
        IconButton(
          onPressed: () => context.push("/notifications"), 
          icon: const Icon(Icons.notifications_active, color: Colors.blue, size: 30)
        ),
      ],
    );
  }
}