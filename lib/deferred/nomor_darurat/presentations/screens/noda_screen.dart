import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../widgets/noda_header.dart';
import '../../data/data.dart';

class NodaScreen extends HookWidget {
  const NodaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine initial province, check if 'JAWA TIMUR' exists, otherwise use first key
    final initialProvince = nodaData.containsKey('JAWA TIMUR') ? 'JAWA TIMUR' : nodaData.keys.first;
    final selectedProvince = useState<String>(initialProvince);

    final currentData = nodaData[selectedProvince.value] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: Column(
        children: [
          // Header dengan JdihHeader
          NodaHeader(
            height: 340, // Sesuaikan sedikit tingginya jika dropdown terpotong
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Tombol back tetap di atas
              children: [
                // 1. Tombol Back (Tetap di kiri sendirian)
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
                
                const SizedBox(width: 12),

                // 2. KONTEN UTAMA (Logo, Judul, Deskripsi, Dropdown)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Kunci agar semua rata kiri mengikuti logo
                    children: [
                      // Baris Logo + Judul
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.phone_outlined,
                              color: AppTheme.jdihBlue,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Nomor Darurat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Dinas Komunikasi & Informatika',
                                  style: TextStyle(
                                    color: Color(0xFFB9D1EE),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Deskripsi (Otomatis sejajar di bawah logo telepon)
                      const Padding(
                        padding: EdgeInsets.only(right: 54), // Memberi jarak agar tidak mepet layar kanan
                        child: Text(
                          'Nomor darurat merupakan layanan cepat tanggal dari pemerintah atau instansi terkait untuk memberikan bantuan kepada masyarakat. Nomor ini dapat dihubungi saat warga menghadapi situasi mendesak, berbahaya, atau yang mengancam jiwa.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFFE0E7FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Region Selector Trigger
                      Padding(
                        padding: const EdgeInsets.only(right: 54),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => _RegionSelectorSheet(
                                regions: nodaData.keys.toList(),
                                onSelected: (val) {
                                  selectedProvince.value = val;
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedProvince.value,
                                    style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.expand_more, color: Color(0xFF6B7280)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Grid Nomor Darurat
          Expanded(
            child: SafeArea(
              top: false,
              child: currentData.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada data nomor darurat',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate width for 2 columns.
                          // We subtract the crossAxisSpacing (16) and divide by 2.
                          final double itemWidth = (constraints.maxWidth - 16) / 2;

                          return Wrap(
                            spacing: 16, // Equivalent to crossAxisSpacing
                            runSpacing: 16, // Equivalent to mainAxisSpacing
                            children: currentData.map((item) {
                              return SizedBox(
                                width: itemWidth,
                                // The height will dynamically adjust to your content!
                                child: _NodaCard(item: item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionSelectorSheet extends StatelessWidget {
  final List<String> regions;
  final ValueChanged<String> onSelected;

  const _RegionSelectorSheet({required this.regions, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Drag handle
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1), // Slate 300
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Wilayah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController, // Crucial for dragging the whole sheet
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final region = regions[index];
                    return InkWell(
                      onTap: () {
                        onSelected(region);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          region,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NodaCard extends StatelessWidget {
  final NodaItem item;

  const _NodaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kecil seperti pada JDIH cards
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          // Number
          Text(
            item.number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          // Call Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () async {
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: item.number,
                );

                final bool didLaunch = await launchUrl(phoneUri);

                if (!didLaunch && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal Membuka Dialer untuk ${item.number}')),
                  );
                }
              },
              icon: const Icon(Icons.phone, size: 18),
              label: const Text(
                'Hubungi Sekarang',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC41C3B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
