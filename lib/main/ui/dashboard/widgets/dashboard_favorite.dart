import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/service_icons.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/service_status_badge.dart';

/// Favorite Widget for Dashboard
class DashboardFavorite extends ConsumerWidget {
  final Widget? textButton;
  final bool? isEditMode;
  const DashboardFavorite({super.key, this.textButton, this.isEditMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteStream = ref.watch(favoriteListProvider);

    return favoriteStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: $e', textAlign: TextAlign.center),
          ),
        ),
        data: (favorites) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _FavoriteHeader(title: 'Layanan Favorit', textButton: textButton),

              if (favorites.isEmpty) const Center(child: Text('No favorites found.'))
              else _FavoriteCards(services: favorites, isEditMode: isEditMode),
            ],
          );
        }
    );
  }
}

/// Header for Favorite Widget
class _FavoriteHeader extends StatelessWidget {
  final String title;
  final Widget? textButton;
  const _FavoriteHeader({required this.title, this.textButton});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ?textButton,
        ],
      ),
    );
  }
}

/// Scrollable Horizontal Cards for Favorite Widget
class _FavoriteCards extends ConsumerWidget {
  final List<ServiceEntity> services;
  final bool? isEditMode;
  const _FavoriteCards({required this.services, this.isEditMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.99,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleTap(context, ref, services[index]),
          child: AnimatedContainer( // Use AnimatedContainer for smoother border transitions
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: isEditMode != null && isEditMode!
                  ? Border.all(color: const Color(0xFF0652C5), width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: Stack(
              clipBehavior: Clip.none, // Allow badges to sit slightly outside
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ServiceIcons(service: services[index]),
                    const SizedBox(height: 4),
                    _buildTitle(services[index]),
                  ],
                ),
                if (isEditMode != null && isEditMode!) EditActionBadge(isFavorite: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(ServiceEntity service) {
    return Text(
      service.title ?? 'No Title',
      style: const TextStyle(fontSize: 10, color: Color(0xFF0652C5), fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _handleTap(BuildContext context, WidgetRef ref, ServiceEntity service) async {
    if (isEditMode != null && isEditMode!) {
      await ref.read(removeFavoriteUseCaseProvider).execute(service.id!);

      ref.invalidate(favoriteListProvider);
    } else {
      context.push(
        '/page-detail',
        extra: {
          'serviceId': service.id,
          'title': service.title,
          'description': service.description
        }
      );
    }
  }
}