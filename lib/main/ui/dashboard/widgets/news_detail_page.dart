import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import '../mock/news_model.dart';

class NewsDetailScreen extends ConsumerWidget {
  final NewsModel news;

  const NewsDetailScreen({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Berita Jawa Timur',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0652C5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.reply, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Berita
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                // Tanggal Berita
                Text(
                  news.date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                // Gambar Berita
                _buildImage(ref),
                const SizedBox(height: 24),
                // Isi Berita
                if (news.paragraphs.isEmpty)
                  Text(
                    'Tidak ada konten berita.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  )
                else
                  ...news.paragraphs.map((paragraph) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        paragraph,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: CachedNetworkImage(
          imageUrl: news.imagePath,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildPlaceholder(),
          useOldImageOnUrlChange: true,
          cacheManager: ref.watch(getCustomCacheManagerProvider),
          placeholder: (context, url) {
            return Container(
              color: Colors.grey.shade100,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0652C5),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Gambar Berita',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
