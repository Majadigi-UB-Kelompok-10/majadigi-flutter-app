import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../main/core/storage.dart';
import '../../core/providers/kh_providers.dart';

class KlinikHoaksDetailScreen extends HookConsumerWidget {
  final String slug;

  const KlinikHoaksDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(getCustomCacheManagerProvider);
    final detailAsync = ref.watch(khNewsDetailProvider(slug: slug));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0044B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Klinik Hoaks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Layanan verifikasi informasi dan deteksi hoaks.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Berita tidak ditemukan'));
          }

          final statusSlug = detail.categorySlug ?? '';
          final statusName = detail.categoryName ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail.publishedAt ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165394/Logo_Provinsi_Jawa_Timur_PNG-1080p_-_FileVector69_1_gwc0de.png',
                          cacheManager: cacheManager,
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.green.shade400, size: 32),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.health_and_safety, color: Colors.red.shade700, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          'KLINIK\nHOAKS',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: detail.imageUrl != null && detail.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: detail.imageUrl!,
                              cacheManager: cacheManager,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                color: Colors.grey.shade100,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
                              ),
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(statusSlug),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  detail.description ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                if (detail.referenceLink != null && detail.referenceLink!.isNotEmpty) ...[
                  const Text(
                    'Link Rujukan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(detail.referenceLink!);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      detail.referenceLink!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Color _getStatusColor(String slug) {
    switch (slug) {
      case 'berita-hoaks':
        return Colors.red.shade900;
      case 'fakta':
        return Colors.green.shade800;
      case 'disinformasi':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade700;
    }
  }
}
