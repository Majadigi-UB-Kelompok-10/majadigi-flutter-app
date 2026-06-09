import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';

import '../mock/news_model.dart';

class HomePageNews extends ConsumerWidget {
  final List<NewsModel> newsList;
  final VoidCallback onSeeAll;

  const HomePageNews({
    super.key,
    required this.newsList,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Berita Jawa Timur', showSeeAll: true, onSeeAll: onSeeAll),
        SizedBox(
          height: 270, // Sesuaikan tinggi agar konten pas
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9), // Padding kanan kiri ListView
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];

              return GestureDetector(
                onTap: () => context.push("/news-detail", extra: news),
                child: Container(
                  width: 280,
                  // Ganti margin dengan padding luar untuk efek box-in-box
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(right: 16), // Jarak antar card
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna background card
                    borderRadius: BorderRadius.circular(24), // Sudut membulat luar
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.09), // Bayangan lembut
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Box Gambar (Di dalam)
                      ClipRRect( // Untuk memotong gambar agar mengikuti sudut membulat
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          // child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                          // Ganti dengan Image.network jika ada URL gambar
                          child: CachedNetworkImage(
                            imageUrl: news.imagePath,
                            fit: BoxFit.cover,
                            cacheManager: ref.watch(getCustomCacheManagerProvider),
                            useOldImageOnUrlChange: true,
                            errorWidget: (context, url, error) => const Center(child: Icon(Icons.image, color: Colors.grey)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Box Teks (Di dalam)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4), // Sedikit padding teks
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              news.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool showSeeAll = false, VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
