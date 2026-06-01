import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import '../../theme/app_theme.dart';
import '../core/providers/jd_providers.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';
import 'widgets/jdih_menu_item.dart';

class JdihScreen extends HookConsumerWidget {
  const JdihScreen({super.key});

  /// Maps jenis value to an icon for the quick access grid.
  static const Map<String, IconData> _jenisIcons = {
    'perda': Icons.grid_view_rounded,
    'pergub': Icons.book,
    'peraturan': Icons.menu_book,
    'perdes': Icons.inventory_2,
    'sk_gub': Icons.balance,
    'instruksi': Icons.back_hand,
    'se': Icons.lightbulb_outline,
    'keputusan': Icons.description,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form state for the search header
    final keywordCtrl = useTextEditingController();
    final nomorCtrl = useTextEditingController();
    final selectedTahun = useState<String?>(null);
    final selectedJenis = useState<String?>(null);

    // Data providers
    final pengumumanAsync = ref.watch(jdPengumumanProvider);
    final jenisAsync = ref.watch(jdJenisFiltersProvider);
    final tahunAsync = ref.watch(jdTahunFiltersProvider);

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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
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
                            CachedNetworkImage(
                              imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Coat_of_arms_of_East_Java.svg/960px-Coat_of_arms_of_East_Java.svg.png',
                              height: 34,
                              cacheManager: ref.watch(getCustomCacheManagerProvider),
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
                          controller: keywordCtrl,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _HeaderField(
                                hintText: 'Nomor',
                                prefixIcon: Icons.numbers,
                                controller: nomorCtrl,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _HeaderDropdownField<String>(
                                hintText: 'Tahun Terbit',
                                value: selectedTahun.value,
                                items: tahunAsync.when(
                                  data: (years) => years
                                      .map((y) => DropdownMenuItem(
                                            value: y.toString(),
                                            child: Text(y.toString(),
                                                style: const TextStyle(fontSize: 11)),
                                          ))
                                      .toList(),
                                  loading: () => [],
                                  error: (_, _) => [],
                                ),
                                onChanged: (v) => selectedTahun.value = v,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _HeaderDropdownField<String>(
                          hintText: 'Jenis Produk Hukum',
                          value: selectedJenis.value,
                          items: jenisAsync.when(
                            data: (filters) => filters
                                .map((f) => DropdownMenuItem(
                                      value: f.value,
                                      child: Text(f.label ?? f.value,
                                          style: const TextStyle(fontSize: 11)),
                                    ))
                                .toList(),
                            loading: () => [],
                            error: (_, _) => [],
                          ),
                          onChanged: (v) => selectedJenis.value = v,
                        ),
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
                              context.push("/jdih/search", extra: {
                                "initialKeyword": keywordCtrl.text.isNotEmpty
                                    ? keywordCtrl.text
                                    : null,
                                "initialNomor": nomorCtrl.text.isNotEmpty
                                    ? nomorCtrl.text
                                    : null,
                                "initialTahun": selectedTahun.value,
                                "initialJenis": selectedJenis.value
                              });
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
                  'Pengumuman Terbaru',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Pengumuman list from API
            SizedBox(
              height: 180,
              child: pengumumanAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Belum ada pengumuman',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return JdihCard(
                        layout: CardLayout.horizontal,
                        category: 'Pengumuman',
                        title: item.judul ?? '',
                        date: item.tanggal,
                        onTap: () {
                          // Welp there is no detail page for pengumuman in figma so..
                          // Navigate to detail with the pengumuman ID
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) =>
                          //         JdihDetailScreen(documentId: item.id),
                          //   ),
                          // );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),

            // Quick access grid from API jenis filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgGray,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowGray.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  spacing: 12.0,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Akses Cepat',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    jenisAsync.when(
                      data: (filters) => LayoutBuilder(
                        builder: (context, constraints) {
                          // 1. Calculate the width of each item.
                          // 4 columns means there are 3 gaps between items.
                          // Gap size is 5 pixels, so total gap width is 15.
                          final itemWidth = (constraints.maxWidth - 15) / 4;

                          return Wrap(
                            spacing: 5, // Equivalent to crossAxisSpacing
                            runSpacing: 10, // Equivalent to mainAxisSpacing
                            alignment: WrapAlignment.start,

                            // 2. Map your filters list into the Wrap children
                            children: filters.map((item) {
                              return SizedBox(
                                width: itemWidth, // Lock the width to force 4 columns
                                // Leave height unconstrained so it naturally fits the content!
                                child: JdihMenuItem(
                                  label: item.label ?? item.value,
                                  ikon: _jenisIcons[item.value] ?? Icons.description,
                                  onTap: () {
                                    context.push("/jdih/category", extra: {
                                      "jenisValue": item.value,
                                      "jenisLabel": item.label ?? item.value
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      // GridView.builder(
                      //   itemCount: filters.length,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   gridDelegate:
                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 4,
                      //         crossAxisSpacing: 5,
                      //         mainAxisSpacing: 10,
                      //         childAspectRatio: 0.89,
                      //       ),
                      //   itemBuilder: (context, index) {
                      //     final item = filters[index];
                      //     return JdihMenuItem(
                      //       label: item.label ?? item.value,
                      //       ikon: _jenisIcons[item.value] ?? Icons.description,
                      //       onTap: () {
                      //         context.push("/jdih/category", extra: {
                      //           "jenisValue": item.value,
                      //           "jenisLabel": item.label ?? item.value
                      //         });
                      //       },
                      //     );
                      //   },
                      // ),
                      loading: () => const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Error: $e'),
                      ),
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
  final TextEditingController? controller;

  const _HeaderField({required this.hintText, this.prefixIcon, this.controller});

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
              controller: controller,
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

class _HeaderDropdownField<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const _HeaderDropdownField({
    required this.hintText,
    this.value,
    this.items = const [],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
          items: items,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 11, color: Colors.black),
        ),
      ),
    );
  }
}
