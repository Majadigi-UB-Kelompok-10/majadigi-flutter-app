import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../main/core/storage.dart';
import '../widgets/rssa_widgets.dart';
import '../../core/providers/rssa_providers.dart';
// import '../../domain/entities/ruangan/rssa_ruangan_entity.dart';
import '../../domain/entities/kelas/rssa_kelas_entity.dart';

class RssaScreen extends HookConsumerWidget {
  const RssaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState<String>('');
    final selectedKelasSlug = useState<String>('');

    // Fetch summary
    final summaryAsync = ref.watch(rssaSummaryProvider);
    
    // Fetch kelas list
    final kelasAsync = ref.watch(rssaKelasProvider);

    // Initial sync of ruangan without filters to populate local cache
    ref.watch(rssaRuanganProvider(search: '', kelas: ''));

    // Watch the local-filtered provider for instant offline filtering
    final ruanganLocalAsync = ref.watch(rssaRuanganLocalProvider(
      search: searchQuery.value,
      kelas: selectedKelasSlug.value,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(ref),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: summaryAsync.when(
                data: (summary) => RoomAvailabilityCard(summary: summary),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error: $e'),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchBar(searchQuery),
            ),
            const SizedBox(height: 16),
            kelasAsync.when(
              data: (kelasList) => _buildFilterChips(kelasList, selectedKelasSlug),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => const SizedBox(),
            ),
            const SizedBox(height: 16),

            // Subtitle indicating search results if a search is active
            if (searchQuery.value.isNotEmpty || selectedKelasSlug.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hasil Pencarian${searchQuery.value.isNotEmpty ? ' "${searchQuery.value}"' : ''}${selectedKelasSlug.value.isNotEmpty ? ' Kelas ${selectedKelasSlug.value}' : ''}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),

            const SizedBox(height: 16),
            Expanded(
              child: ruanganLocalAsync.when(
                data: (filteredRooms) {
                  if (filteredRooms.isEmpty) {
                    return const Center(
                      child: Text(
                        'Data Tidak Ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      return RoomListItem(room: filteredRooms[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: 'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165362/Rssa_Logo_mngnmt.png',
                  cacheManager: ref.watch(getCustomCacheManagerProvider),
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Info Kamar Rawat,',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                'RS Saiful Anwar, Malang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ValueNotifier<String> searchQuery) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          searchQuery.value = value;
        },
        decoration: InputDecoration(
          hintText: 'Masukkan Nama Ruangan',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFilterChips(List<RssaKelasEntity> kelasList, ValueNotifier<String> selectedKelasSlug) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "Semua" chip
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => selectedKelasSlug.value = '',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedKelasSlug.value == '' ? Colors.blue.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade700),
                ),
                child: Text(
                  'Semua',
                  style: TextStyle(
                    color: selectedKelasSlug.value == '' ? Colors.white : Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          ...kelasList.map((kelas) {
            final isSelected = selectedKelasSlug.value == kelas.slug;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => selectedKelasSlug.value = kelas.slug,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade700 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Text(
                    kelas.nama,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
