import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/service/service_providers.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/ui/dashboard/mock/service_data.dart';

/// Main Service Grid for Service Page
class ServicePageServiceGrid extends ConsumerWidget {
  final bool isEditMode;
  const ServicePageServiceGrid({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(serviceListProvider);

    // Create Local copy of favorites
    final favoriteList = serviceData;

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
                  favoriteList: favoriteList,
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
  const _ServiceGridHeader({super.key, required this.title});

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
class _ServiceGridCreator extends StatelessWidget {
  final bool isEditMode;
  final ServiceEntity service;
  final List<ServiceEntity> favoriteList;
  const _ServiceGridCreator({super.key, required this.isEditMode, required this.favoriteList, required this.service});

  @override
  Widget build(BuildContext context) {
    final isFavorite = favoriteList.contains(service);

    return GestureDetector(
      onTap: isEditMode
          ? () {
        if (!isFavorite &&
            favoriteList.length >= 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maksimal 4 favorit'),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        } else {
          //
        }
      } : () => context.push(
        '/page-detail',
        extra: {
          'serviceId': service.id,
          'title': service.title,
          'description': service.description
        }
      ),
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: isEditMode && isFavorite
              ? Border.all(color: const Color(0xFF0652C5), width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.apps, color: Colors.blue),
                const SizedBox(height: 4),
                Text(
                  service.title!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF0652C5),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // Badge saat favorit dan bukan edit mode
            if (isFavorite && !isEditMode)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      color: Colors.white, size: 10),
                ),
              ),
            // Icon edit saat edit mode
            if (isEditMode)
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                    isFavorite ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.remove : Icons.add,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}