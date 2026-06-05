import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../theme/app_theme.dart';
import '../core/providers/jd_providers.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';

class JdihSearchScreen extends HookConsumerWidget {
  final String? initialKeyword;
  final String? initialNomor;
  final String? initialTahun;
  final String? initialJenis;

  const JdihSearchScreen({
    super.key,
    this.initialKeyword,
    this.initialNomor,
    this.initialTahun,
    this.initialJenis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Submitted search params (triggers API call)
    final keyword = useState<String?>(initialKeyword);
    final nomor = useState<String?>(initialNomor);
    final tahun = useState<String?>(initialTahun);
    final jenis = useState<String?>(initialJenis);
    final sort = useState<String?>(null);
    final page = useState<int>(1);

    // Text controller for the search bar
    final searchCtrl = useTextEditingController(
      text: initialKeyword ?? '',
    );

    // Watch search results
    final searchAsync = ref.watch(jdSearchDokumenProvider(
      keyword: keyword.value,
      nomor: nomor.value,
      tahun: tahun.value,
      jenis: jenis.value,
      sort: sort.value,
      page: page.value,
      limit: 10,
    ));

    // Build the display title
    final searchTitle = keyword.value != null && keyword.value!.isNotEmpty
        ? 'Hasil Pencarian: ${keyword.value}'
        : 'Hasil Pencarian';

    // Sort filter options
    final sortFilters = [
      ('Terbaru', null),
      ('Populer', 'populer'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            JdihHeader(
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
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
                      Expanded(
                        child: Text(
                          searchTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SearchBar(
                    controller: searchCtrl,
                    onSubmitted: (value) {
                      keyword.value = value.isNotEmpty ? value : null;
                      page.value = 1;
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sort filter chips
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
                  ...sortFilters.map((entry) {
                    final isSelected = sort.value == entry.$2;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          sort.value = entry.$2;
                          page.value = 1;
                        },
                        child: _FilterChipButton(
                          label: entry.$1,
                          selected: isSelected,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Pagination progress indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: searchAsync.when(
                  data: (result) {
                    final pagination = result.pagination;
                    if (pagination?.total != null && pagination!.total! > 0) {
                      final totalPages = (pagination.total! / (pagination.limit ?? 10)).ceil();
                      final progress = page.value / totalPages;
                      return Row(
                        children: [
                          SizedBox(
                            width: 122,
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: const Color(0xFFC7CCD3),
                              color: const Color(0xFF8D939C),
                              borderRadius: const BorderRadius.all(Radius.circular(999)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${pagination.total} dokumen',
                            style: const TextStyle(
                              color: Color(0xFF8D939C),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                  loading: () => const SizedBox(
                    width: 122,
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: Color(0xFFC7CCD3),
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                  ),
                  error: (_, _) => const SizedBox(),
                ),
              ),
            ),

            // Results list
            Expanded(
              child: searchAsync.when(
                data: (result) {
                  final items = result.results;
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada hasil ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: _SourceDataPanel(),
                        );
                      }

                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: JdihCard(
                          layout: CardLayout.vertical,
                          status: item.status,
                          title: item.judul ?? '',
                          description: item.ringkasan,
                          category: item.jenis?.toUpperCase(),
                          views: item.jumlahView != null
                              ? _formatViews(item.jumlahView!)
                              : null,
                          date: item.tanggal,
                          onTap: () {
                            context.push("/jdih/detail", extra: {
                              "documentId": item.id
                            });
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}k';
    }
    return views.toString();
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _SearchBar({required this.controller, required this.onSubmitted});

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
          const Icon(Icons.search, color: Colors.grey, size: 25),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                hintText: 'Cari dokumen...',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
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
