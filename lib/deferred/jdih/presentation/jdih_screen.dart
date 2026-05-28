import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../data/jdih_document.dart';
import '../data/models/jdih_quick_access_item.dart';
import 'jdih_detail_screen.dart';
import 'jdih_search_screen.dart';
import 'jdih_category_screen.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';
import 'widgets/jdih_menu_item.dart';

class JdihScreen extends StatelessWidget {
  const JdihScreen({super.key});

  static const List<JdihDocument> _newsItems = [
    JdihDocument(
      category: 'Surat Edaran',
      title: 'Layanan Digital Baru Kini Tersedia Untuk Publik',
      nomor: '800/76/200.1.1/2026',
      tahun: '2026',
      tglPenetapan: '24 Okt 2026',
      status: 'Berlaku',
      pdfUrl: 'https://jdih.jatimprov.go.id/dokumen-1.pdf',
      pdfSize: '1.2 MB',
    ),
    JdihDocument(
      category: 'Surat Edaran',
      title: 'Sosialisasi Perda Dilaksanakan Serentak di Seluruh Kecamatan',
      nomor: '188/12/013/2026',
      tahun: '2026',
      tglPenetapan: '22 Okt 2026',
      status: 'Berlaku',
      pdfUrl: 'https://jdih.jatimprov.go.id/dokumen-2.pdf',
      pdfSize: '980 KB',
    ),
    JdihDocument(
      category: 'Surat Edaran',
      title: 'Pembaruan Data Produk Hukum Daerah Kini Lebih Cepat',
      nomor: '100.3.2/54/2026',
      tahun: '2026',
      tglPenetapan: '20 Okt 2026',
      status: 'Berlaku',
      pdfUrl: 'https://jdih.jatimprov.go.id/dokumen-3.pdf',
      pdfSize: '1.1 MB',
    ),
  ];

  static const List<JdihQuickAccessItem> _quickAccessItems = [
    JdihQuickAccessItem(label: 'Perda', icon: Icons.grid_view_rounded),
    JdihQuickAccessItem(label: 'Pergub', icon: Icons.book),
    JdihQuickAccessItem(label: 'Peraturan', icon: Icons.menu_book),
    JdihQuickAccessItem(label: 'Perdes', icon: Icons.inventory_2),
    JdihQuickAccessItem(label: 'SK Gub', icon: Icons.balance),
    JdihQuickAccessItem(label: 'Interuksi', icon: Icons.back_hand),
    JdihQuickAccessItem(label: 'SE', icon: Icons.lightbulb_outline),
    JdihQuickAccessItem(label: 'Keputusan', icon: Icons.description),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            JdihHeader(
              height: 297,
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.only(right: 27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Coat_of_arms_of_East_Java.svg/960px-Coat_of_arms_of_East_Java.svg.png',
                              height: 34,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'JDIH Jawa Timur',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        const Padding(
                          padding: EdgeInsets.only(right: 28),
                          child: Text(
                            'Jaringan Dokumentasi dan Informasi Hukum (JDIH) Provinsi Jawa Timur adalah wadah pengelolaan dan penyebarluasan dokumen hukum daerah.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _HeaderField(
                          hintText: 'Keywords atau Nama Dokumen',
                          prefixIcon: Icons.search,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _HeaderField(
                                hintText: 'Nomor',
                                prefixIcon: Icons.numbers,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _HeaderDropdownField(
                                hintText: 'Tahun Terbit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _HeaderDropdownField(hintText: 'Jenis Produk Hukum'),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const JdihSearchScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Cari Sekarang',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Perda Terbaru',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _newsItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final item = _newsItems[index];
                  return JdihCard(
                    layout: CardLayout.horizontal,
                    category: item.category,
                    status: item.status,
                    title: item.title,
                    date: item.tglPenetapan,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JdihDetailScreen(document: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgGray,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowGray.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(10, 18, 10, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Akses Cepat',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: AppTheme.jdihBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView.builder(
                      itemCount: _quickAccessItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.89,
                          ),
                      itemBuilder: (context, index) {
                        final item = _quickAccessItems[index];
                        return JdihMenuItem(
                          label: item.label,
                          ikon: item.icon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JdihCategoryScreen(categoryName: item.label),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppTheme.jdihBlue,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUMBER DATA:',
                            style: TextStyle(
                              color: AppTheme.jdihBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'JDIH - Biro Hukum Sekretariat Daerah Pemerintah Provinsi Jawa Timur',
                            style: TextStyle(
                              color: Color(0xFF65717D),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: Colors.grey, size: 15),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDropdownField extends StatelessWidget {
  final String hintText;

  const _HeaderDropdownField({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hintText,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}
