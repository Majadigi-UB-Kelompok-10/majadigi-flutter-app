import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/providers/sd_providers.dart';
import '../widgets/hotel_list_item.dart';
import '../widgets/sidita_map_view.dart';

class SiditaHotelScreen extends HookConsumerWidget {
  const SiditaHotelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currentPage = useState(1);
    final searchQuery = useState<String?>(null);

    final hotelsAsync = ref.watch(
      sdHotelsProvider(
        search: searchQuery.value,
        page: currentPage.value,
        limit: 10,
      ),
    );

    final mapAsync = ref.watch(
      sdHotelMapProvider(search: searchQuery.value),
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
              const Text(
                'Akomodasi Hotel',
                style: TextStyle(
                  color: Color(0xFF0F3B8C),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Temukan penginapan terbaik untuk melengkapi perjalanan Anda menjelajahi keindahan Jawa Timur.',
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                        decoration: const InputDecoration(
                          hintText: 'Cari hotel',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      searchQuery.value = searchController.text.isEmpty ? null : searchController.text;
                      currentPage.value = 1;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3B8C),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Hotel Table
              hotelsAsync.when(
                data: (result) {
                  final (hotels, pagination) = result;
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F3B8C),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'NAMA HOTEL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'KAB/KOTA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Table Body
                            if (hotels.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Center(child: Text('Tidak ada hotel ditemukan')),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: hotels.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: HotelListItem(
                                      hotel: hotels[index],
                                      onTap: () {
                                        final id = hotels[index].id;
                                        if (id != null) {
                                          context.push('/sidita/hotel/$id');
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      if (pagination != null && (pagination.totalPages ?? 0) > 1) ...[
                        const SizedBox(height: 24),
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
              const SizedBox(height: 40),

              // Peta Sebaran Hotel
              const Text(
                'Peta Sebaran Hotel',
                style: TextStyle(
                  color: Color(0xFF0F3B8C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualisasi lokasi penginapan terbaik di wilayah Jawa Timur.',
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
                              thumbnailUrl: p.gambarUrl,
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
