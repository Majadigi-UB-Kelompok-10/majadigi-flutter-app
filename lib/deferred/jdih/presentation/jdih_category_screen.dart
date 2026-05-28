import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../data/models/jdih_category_item.dart';
import 'jdih_detail_screen.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';

class JdihCategoryScreen extends StatelessWidget {
  final String categoryName;

  const JdihCategoryScreen({super.key, required this.categoryName});

  static const List<JdihCategoryItem> _items = [
    JdihCategoryItem(
      category: 'PERDA',
      status: 'Berlaku',
      nomor: '5',
      tahun: '2023',
      title: 'Peraturan Daerah Nomor 5 Tahun 2023 tentang Penyelenggaraan Ketertiban Umum dan Ketentraman Masyarakat.',
      date: '12 Nov 2023',
      views: '1.2k',
      description: 'Ringkasan singkat tentang isi Perda nomor 5 tahun 2023...',
      pdfSize: '1.2 MB',
      tglPenetapan: '12 Nov 2023',
    ),
    JdihCategoryItem(
      category: 'PERDA',
      status: 'Berlaku',
      nomor: '2',
      tahun: '2022',
      title: 'Peraturan Daerah Nomor 2 Tahun 2022 tentang Pengelolaan Sampah',
      date: '05 Mei 2022',
      views: '856',
      description: 'Ringkasan singkat tentang pengelolaan sampah...',
      pdfSize: '980 KB',
      tglPenetapan: '05 Mei 2022',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: Column(
        children: [
          JdihHeader(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produk Hukum: ${categoryName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'PERATURAN DAERAH PROVINSI',
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
                const SizedBox(height: 14),
                // search box inside header
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Color(0xFF9AA5B4)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cari nomor atau judul Perda...',
                          style: TextStyle(color: Color(0xFF9AA5B4), fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // chips
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _SmallChip(label: 'Semua Tahun', selected: true),
                SizedBox(width: 10),
                _SmallChip(label: '2024'),
                SizedBox(width: 10),
                _SmallChip(label: '2023'),
                SizedBox(width: 10),
                _SmallChip(label: '2022'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 122,
                child: LinearProgressIndicator(
                  value: 1,
                  minHeight: 6,
                  backgroundColor: Color(0xFFC7CCD3),
                  color: Color(0xFF8D939C),
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final it = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: JdihCard(
                    layout: CardLayout.vertical,
                    status: it.status,
                    category: it.category,
                    title: it.title,
                    description: it.description,
                    views: it.views,
                    date: it.date,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => JdihDetailScreen(document: it.toDocument()),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _SmallChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? AppTheme.jdihBlue : const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF3B4857),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
