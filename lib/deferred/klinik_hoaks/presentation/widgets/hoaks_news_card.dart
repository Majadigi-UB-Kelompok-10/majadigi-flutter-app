import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../domain/entities/news/kh_news_entity.dart';

class HoaksNewsCard extends StatelessWidget {
  final KhNewsEntity news;
  final CacheManager cacheManager;
  final VoidCallback? onTap;

  const HoaksNewsCard({
    super.key,
    required this.news,
    required this.cacheManager,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusSlug = news.categorySlug ?? '';
    final statusName = news.categoryName ?? '';

    Color statusColor;
    Color statusBgColor;

    switch (statusSlug) {
      case 'berita-hoaks':
        statusColor = Colors.red.shade900;
        statusBgColor = Colors.pink.shade100;
        break;
      case 'fakta':
        statusColor = Colors.green.shade800;
        statusBgColor = Colors.green.shade100;
        break;
      case 'disinformasi':
        statusColor = Colors.orange.shade800;
        statusBgColor = Colors.orange.shade100;
        break;
      default:
        statusColor = Colors.grey.shade700;
        statusBgColor = Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Tags and Logos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusName,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Left logos
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165394/Logo_Provinsi_Jawa_Timur_PNG-1080p_-_FileVector69_1_gwc0de.png',
                          cacheManager: cacheManager,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.verified, color: Colors.green.shade400, size: 24),
                      ],
                    ),
                  ],
                ),
                // Klinik Hoaks logo
                Row(
                  children: [
                    Icon(Icons.health_and_safety, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'KLINIK\nHOAKS',
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image with Overlay Tag
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: news.imageUrl != null && news.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: news.imageUrl!,
                          cacheManager: cacheManager,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 120,
                            color: Colors.grey.shade100,
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 120,
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Center(
                            child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              news.title ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            // Date
            Text(
              news.publishedAt ?? '',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
