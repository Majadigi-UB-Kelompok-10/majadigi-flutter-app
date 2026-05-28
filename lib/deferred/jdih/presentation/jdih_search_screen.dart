import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../data/models/jdih_search_result_item.dart';
import 'jdih_detail_screen.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';

class JdihSearchScreen extends StatelessWidget {
  const JdihSearchScreen({super.key});

  static const List<String> _yearFilters = ['Terbaru', 'Populer', 'Tahun 2025'];

  static const List<JdihSearchResultItem> _results = [
    JdihSearchResultItem(
      category: 'PERDA',
      nomor: '5',
      tahun: '2023',
      title: 'Peraturan daerah nomor 5 tahun 2023 tentang penyelenggaraan ketertiban umum dan ketentraman masyarakat',
      status: 'Terbaru',
      description:
          'Peraturan Daerah tentang Pengelolaan Keuangan Daerah Provinsi Jawa Timur Tahun Anggaran 2023',
      date: '15 Jan 2023',
      views: '1.2k',
      pdfSize: '1.2 MB',
      tglPenetapan: '15 Jan 2023',
    ),
    JdihSearchResultItem(
      category: 'PERDA',
      nomor: '5',
      tahun: '2023',
      title: 'No. 5 Tahun 2023',
      status: 'Terbaru',  
      description:
          'Penyelenggaraan Ketentraman, Ketertiban Umum, dan Perlindungan Masyarakat di Lingkungan Kabupaten/Kota',
      date: '22 Mar 2023',
      views: '856',
      pdfSize: '980 KB',
      tglPenetapan: '22 Mar 2023',
    ),
    JdihSearchResultItem(
      category: 'PERDA',
      nomor: '8',
      tahun: '2023',
      title: 'No. 8 Tahun 2023',
      status: 'Terbaru',
      description:
          'Pajak Daerah dan Retribusi Daerah Sebagai Upaya Optimalisasi Pendapatan Asli Daerah',
      date: '10 Jun 2023',
      views: '432',
      pdfSize: '764 KB',
      tglPenetapan: '10 Jun 2023',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: Column(
        children: [
          JdihHeader(
  height: 220, // Sesuaikan tinggi agar tidak terlalu kosong
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      // BARIS ICON BACK DAN JUDUL HASIL PENCARIAN
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44, // Sesuaikan ukuran lingkaran agar pas
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // JUDUL HASIL PENCARIAN (Sejajar lurus dengan icon)
          const Expanded(
            child: Text(
              'Hasil Pencarian: Ketertiban Umum',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20, // Ukuran font diturunkan agar proporsional
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 24),
      
      // SEARCH BAR PUTIH (Sesuai Gambar)
      _HeaderField(
        hintText: 'Cari nomor atau judul Perda...',
        prefixIcon: Icons.search,
      ),
    ],
  ),
),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const _FilterChipButton(
                  label: 'Filter',
                  selected: true,
                  icon: Icons.tune,
                ),
                const SizedBox(width: 10),
                ..._yearFilters.map(
                  (label) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _FilterChipButton(label: label),
                  ),
                ),
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
              itemCount: _results.length + 1,
              itemBuilder: (context, index) {
                if (index == _results.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: _SourceDataPanel(),
                  );
                }

                final item = _results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: JdihCard(
                    layout: CardLayout.vertical,
                    status: item.status,
                    title: item.title,
                    description: item.description,
                    category: item.category,
                    views: item.views,
                    date: item.date,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => JdihDetailScreen(document: item.toDocument()),
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

class _HeaderField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;

  const _HeaderField({required this.hintText, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: Colors.grey, size: 25),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? icon;

  const _FilterChipButton({
    required this.label,
    this.selected = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? AppTheme.jdihBlue : const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF4B5563),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class _SourceDataPanel extends StatelessWidget {
  const _SourceDataPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppTheme.jdihBlue,
            child: Icon(Icons.info_outline, color: Colors.white, size: 13),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUMBER DATA',
                  style: TextStyle(
                    color: AppTheme.jdihBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'JDIH - Biro Hukum Sekretariat Daerah\nPemerintah Provinsi Jawa Timur',
                  style: TextStyle(
                    color: Color(0xFF596273),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
