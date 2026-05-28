import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../main/core/storage.dart';
import '../../core/providers/kh_providers.dart';
import '../widgets/hoaks_news_card.dart';
import '../widgets/hoaks_stat_card.dart';
import '../widgets/hoaks_promo_carousel.dart';

class KlinikHoaksMainScreen extends HookConsumerWidget {
  const KlinikHoaksMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String>('');
    final cacheManager = ref.watch(getCustomCacheManagerProvider);

    // Watch stats (SWR)
    final statsAsync = ref.watch(khStatsProvider);

    // Watch news (SWR) or search results
    final isSearching = searchQuery.value.isNotEmpty;
    final newsAsync = isSearching
        ? ref.watch(khNewsSearchProvider(query: searchQuery.value))
        : ref.watch(khNewsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: CachedNetworkImage(
            imageUrl: 'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165394/Logo_Provinsi_Jawa_Timur_PNG-1080p_-_FileVector69_1_gwc0de.png',
            cacheManager: cacheManager,
            fit: BoxFit.contain,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Klinik Hoaks',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Layanan verifikasi informasi dan deteksi hoaks.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cek Hoaks atau Fakta?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Kata Kunci',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (isSearching) ...[
              newsAsync.when(
                data: (newsList) => Text(
                  '${newsList.length} Result Found for "${searchQuery.value}"',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                loading: () => const SizedBox(),
                error: (e, st) => const SizedBox(),
              ),
              const SizedBox(height: 16),
            ] else ...[
              const HoaksPromoCarousel(),
              const SizedBox(height: 24),
              statsAsync.when(
                data: (stats) => GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.6,
                  children: stats.map((stat) {
                    final colors = _getStatColors(stat.categorySlug ?? '');
                    return HoaksStatCard(
                      title: stat.categoryName ?? '',
                      count: '${stat.totalNews ?? 0}',
                      backgroundColor: colors.$1,
                      textColor: colors.$2,
                      iconColor: colors.$3,
                      icon: _getStatIcon(stat.categorySlug ?? ''),
                    );
                  }).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error loading stats')),
              ),
              const SizedBox(height: 32),
              Text(
                'Recent News',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // News List
            newsAsync.when(
              data: (newsList) {
                if (newsList.isEmpty && isSearching) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Text(
                        'No news found for "${searchQuery.value}"',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return HoaksNewsCard(
                      news: newsList[index],
                      cacheManager: cacheManager,
                      onTap: () => context.push(
                        '/klinik-hoaks/detail/${newsList[index].slug}',
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error loading news')),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, Color) _getStatColors(String slug) {
    switch (slug) {
      case 'berita-hoaks':
        return (Colors.pink.shade100, Colors.red.shade900, Colors.red.shade700);
      case 'disinformasi':
        return (Colors.orange.shade100, Colors.orange.shade900, Colors.orange.shade800);
      case 'fakta':
        return (Colors.green.shade100, Colors.green.shade900, Colors.green.shade800);
      case 'hate-speech':
        return (Colors.grey.shade300, Colors.black87, Colors.grey.shade700);
      default:
        return (Colors.blue.shade100, Colors.blue.shade900, Colors.blue.shade800);
    }
  }

  IconData _getStatIcon(String slug) {
    switch (slug) {
      case 'berita-hoaks':
        return Icons.chat_bubble_outline;
      case 'disinformasi':
        return Icons.cancel_outlined;
      case 'fakta':
        return Icons.check_box_outlined;
      case 'hate-speech':
        return Icons.thumb_down_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
