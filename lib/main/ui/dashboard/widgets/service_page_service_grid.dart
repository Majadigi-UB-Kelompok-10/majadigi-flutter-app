import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/service_icons.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/widgets/service_status_badge.dart';

/// Main Service Grid for Service Page
class ServicePageServiceGrid extends ConsumerWidget {
  final bool isEditMode;
  final int favoriteListLength;
  const ServicePageServiceGrid({super.key, required this.isEditMode, required this.favoriteListLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(serviceListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _ServiceGridHeader(title: 'Semua Layanan'),

        // List
        asyncList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: $e', textAlign: TextAlign.center),
            ),
          ),
          data: (services) {
            if (services.isEmpty) {
              return const Center(child: Text('No services found.'));
            }

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
                final service = services[index];

                return _ServiceGridCreator(
                  service: service,
                  isEditMode: isEditMode,
                  favoriteListLength: favoriteListLength,
                );
              },
            );
          }
        ),
      ],
    );
  }
}

/// Header for Service Grid
class _ServiceGridHeader extends StatelessWidget {
  final String title;
  const _ServiceGridHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
      ),
    );
  }
}

/// Services Grid Items
class _ServiceGridCreator extends ConsumerWidget {
  final bool isEditMode;
  final ServiceEntity service;
  final int favoriteListLength;
  const _ServiceGridCreator({required this.isEditMode, required this.service, required this.favoriteListLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteList = ref.watch(favoriteListProvider);
    final favoriteListSnapshot = favoriteList.value ?? [];
    final isFavorite = favoriteListSnapshot.any((e) => e.id == service.id);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context, ref, isFavorite, favoriteListSnapshot.length),
      child: AnimatedContainer( // Use AnimatedContainer for smoother border transitions
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: isEditMode && isFavorite
              ? Border.all(color: const Color(0xFF0652C5), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Stack(
          clipBehavior: Clip.none, // Allow badges to sit slightly outside
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ServiceIcons(service: service),
                const SizedBox(height: 4),
                _buildTitle(),
              ],
            ),
            if (isFavorite && !isEditMode) ServiceStatusBadge(),
            if (isEditMode) EditActionBadge(isFavorite: isFavorite),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref, bool isFavorite, int snapshotLength) async {
    if (isEditMode) {
      if (isFavorite) {
        await ref.read(removeFavoriteUseCaseProvider).execute(service.id!);
      } else {
        if (snapshotLength >= favoriteListLength) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maksimal $favoriteListLength favorit'),
              duration: const Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          await ref.read(addFavoriteUseCaseProvider).execute(service.id!);
        }
      }

      ref.invalidate(favoriteListProvider);
    } else {
      context.push(
        '/page-detail',
        extra: {
          'serviceId': service.id,
          'title': service.longTitle,
          'description': service.description
        }
      );
    }
  }

  Widget _buildTitle() {
    return Text(
      service.title ?? 'No Title',
      style: const TextStyle(fontSize: 10, color: Color(0xFF0652C5), fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}