import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';
import 'package:majadigi_mobile_rebuild/main/core/credentials.dart';

class ServiceIcons extends ConsumerWidget {
  final ServiceEntity service;
  const ServiceIcons({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    if (service.iconUrl == null) return const Icon(Icons.apps, color: Colors.blue);

    return Expanded(
      child: Center(
          child: CachedNetworkImage(
            imageUrl: service.iconUrl!,
            fit: BoxFit.contain,
            cacheManager: cacheManager,
            errorWidget: (context, url, error) => const Icon(Icons.apps, color: Colors.blue),
            placeholder: (context, url) => const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
          )
      ),
    );
  }
}