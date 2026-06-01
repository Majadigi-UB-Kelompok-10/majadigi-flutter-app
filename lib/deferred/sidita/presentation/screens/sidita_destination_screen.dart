import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/providers/sd_providers.dart';
import '../widgets/destination_list_item.dart';
import '../widgets/sidita_map_view.dart';

class SiditaDestinationScreen extends HookConsumerWidget {
  const SiditaDestinationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currentPage = useState(1);
    final searchQuery = useState<String?>(null);

    final destinationsAsync = ref.watch(
      sdDestinationsProvider(
        search: searchQuery.value,
        page: currentPage.value,
        limit: 10,
      ),
    );

    final mapAsync = ref.watch(
      sdDestinationMapProvider(search: searchQuery.value),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F3B8C)),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165251/Sidita_Logo_ze4yom.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'SIDITA',
              style: TextStyle(
                color: Color(0xFF0F3B8C),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3B8C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'HERITAGE CURATOR',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Jelajahi Warisan\nLuhur Jawa\nTimur',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Temukan destinasi wisata pilihan yang mengedepankan nilai budaya, sejarah, dan keasrian alam nusantara.',
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Destinasi Pilihan Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Destinasi Pilihan',
                      style: TextStyle(
                        color: Color(0xFF0F3B8C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Menampilkan urutan destinasi\nberdasarkan kabupaten/kota',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (value) {
                          searchQuery.value = value.isEmpty ? null : value;
                          currentPage.value = 1;
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari kabupaten atau objek wisata...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          icon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                          suffixIcon: searchQuery.value != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    searchController.clear();
                                    searchQuery.value = null;
                                    currentPage.value = 1;
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OBJEK WISATA & LOKASI',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Divider(),
                    // List of Destinations
                    destinationsAsync.when(
                      data: (result) {
                        final (destinations, pagination) = result;
                        if (destinations.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: Text('Tidak ada destinasi ditemukan')),
                          );
                        }
                        return Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: destinations.length,
                              separatorBuilder: (_, _) => const Divider(),
                              itemBuilder: (context, index) {
                                return DestinationListItem(
                                  destination: destinations[index],
                                  onTap: () {
                                    final id = destinations[index].id;
                                    if (id != null) {
                                      context.push('/sidita/destinasi/$id');
                                    }
                                  },
                                );
                              },
                            ),
                            if (pagination != null && (pagination.totalPages ?? 0) > 1) ...[
                              const SizedBox(height: 16),
                              _buildPagination(
                                currentPage: currentPage.value,
                                totalPages: pagination.totalPages ?? 1,
                                onPageChanged: (page) => currentPage.value = page,
                              ),
                            ],
                          ],
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(child: Text('Gagal memuat: $e')),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Peta Sebaran Wisata
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Peta Sebaran Wisata',
                  style: TextStyle(
                    color: Color(0xFF0F3B8C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualisasi sebaran objek wisata heritage dan alam di seluruh wilayah Jawa Timur untuk memudahkan eksplorasi Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              mapAsync.when(
                data: (mapData) {
                  if (mapData == null) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Text('Peta tidak tersedia')),
                    );
                  }
                  final (center, points) = mapData;
                  return SiditaMapView(
                    centerLat: center.lat ?? -7.6979,
                    centerLng: center.lng ?? 112.4939,
                    zoom: (center.zoom ?? 8).toDouble(),
                    points: points
                        .where((p) => p.lat != null && p.lng != null)
                        .map((p) => SiditaMapPoint(
                              lat: p.lat!,
                              lng: p.lng!,
                              nama: p.nama,
                              thumbnailUrl: p.gambarUrlThumbnail,
                            ))
                        .toList(),
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 200,
                  child: Center(child: Text('Gagal memuat peta: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination({
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentPage > 1)
          _buildPageButton('<', () => onPageChanged(currentPage - 1)),
        ...List.generate(
          totalPages > 5 ? 5 : totalPages,
          (i) {
            final page = i + 1;
            return _buildPageButton(
              '$page',
              () => onPageChanged(page),
              isActive: page == currentPage,
            );
          },
        ),
        if (currentPage < totalPages)
          _buildPageButton('>', () => onPageChanged(currentPage + 1)),
      ],
    );
  }

  Widget _buildPageButton(String text, VoidCallback onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F3B8C) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFF0F3B8C) : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
