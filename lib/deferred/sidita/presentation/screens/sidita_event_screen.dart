import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/providers/sd_providers.dart';
import '../widgets/event_card.dart';

class SiditaEventScreen extends HookConsumerWidget {
  const SiditaEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState(1);
    final selectedArea = useState<String?>(null);
    final selectedBulan = useState<String?>(null);
    final selectedTahun = useState<int?>(null);

    final areasAsync = ref.watch(sdAreasProvider);
    final yearsAsync = ref.watch(sdAvailableYearsProvider);

    final eventsAsync = ref.watch(
      sdEventsProvider(
        area: selectedArea.value,
        bulan: selectedBulan.value,
        tahun: selectedTahun.value,
        page: currentPage.value,
        limit: 10,
      ),
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
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Daftar Event',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'KALENDER BUDAYA',
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Jelajahi Kemeriahan\nJawa Timur',
                style: TextStyle(
                  color: Color(0xFF0F3B8C),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),

              // Filter Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KABUPATEN/KOTA',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Area Dropdown
                    areasAsync.when(
                      data: (areas) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: selectedArea.value,
                              isExpanded: true,
                              hint: const Text('Semua Wilayah', style: TextStyle(fontWeight: FontWeight.w500)),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('Semua Wilayah')),
                                ...areas.map((a) => DropdownMenuItem(
                                      value: a.nama,
                                      child: Text(a.nama ?? ''),
                                    )),
                              ],
                              onChanged: (value) {
                                selectedArea.value = value;
                                currentPage.value = 1;
                              },
                            ),
                          ),
                        );
                      },
                      loading: () => _buildDropdownPlaceholder('Memuat wilayah...'),
                      error: (_, _) => _buildDropdownPlaceholder('Gagal memuat wilayah'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BULAN',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String?>(
                                    value: selectedBulan.value,
                                    isExpanded: true,
                                    hint: const Text('Semua', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                    items: [
                                      const DropdownMenuItem(value: null, child: Text('Semua Bulan')),
                                      ...List.generate(12, (i) {
                                        final monthNames = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
                                        return DropdownMenuItem(
                                          value: '${i + 1}',
                                          child: Text(monthNames[i]),
                                        );
                                      }),
                                    ],
                                    onChanged: (value) {
                                      selectedBulan.value = value;
                                      currentPage.value = 1;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TAHUN',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              yearsAsync.when(
                                data: (years) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int?>(
                                        value: selectedTahun.value,
                                        isExpanded: true,
                                        hint: const Text('Semua', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                        items: [
                                          const DropdownMenuItem(value: null, child: Text('Semua Tahun')),
                                          ...years.map((y) => DropdownMenuItem(
                                                value: y,
                                                child: Text('$y'),
                                              )),
                                        ],
                                        onChanged: (value) {
                                          selectedTahun.value = value;
                                          currentPage.value = 1;
                                        },
                                      ),
                                    ),
                                  );
                                },
                                loading: () => _buildDropdownPlaceholder('...'),
                                error: (_, _) => _buildDropdownPlaceholder('Error'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Event Grid
              eventsAsync.when(
                data: (result) {
                  final (events, pagination) = result;
                  if (events.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Tidak ada event ditemukan')),
                    );
                  }
                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                            event: events[index],
                            onTap: () {
                              final id = events[index].id;
                              if (id != null) {
                                context.push('/sidita/event/$id');
                              }
                            },
                          );
                        },
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPlaceholder(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
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
