import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../theme/app_theme.dart';
import '../core/providers/jd_providers.dart';
import 'widgets/jdih_card.dart';
import 'widgets/jdih_header.dart';

class JdihCategoryScreen extends HookConsumerWidget {
  final String jenisValue;
  final String jenisLabel;

  const JdihCategoryScreen({
    super.key,
    required this.jenisValue,
    required this.jenisLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTahun = useState<String?>(null);
    final searchKeyword = useState<String?>(null);
    final searchCtrl = useTextEditingController();
    final currentPage = useState<int>(1);

    // Fetch available years for this jenis
    final tahunAsync = ref.watch(jdTahunByJenisProvider(jenisValue));

    // Fetch documents for this jenis with filters
    final dokumenAsync = ref.watch(jdDokumenByJenisProvider(
      jenis: jenisValue,
      keyword: searchKeyword.value,
      tahun: selectedTahun.value,
      page: currentPage.value,
      limit: 10,
    ));

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
                      onTap: () => context.pop(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
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
                            'Produk Hukum: $jenisLabel',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jenisLabel.toUpperCase(),
                            style: const TextStyle(
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
                    children: [
                      const Icon(Icons.search, color: Color(0xFF9AA5B4)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchCtrl,
                          onSubmitted: (value) {
                            searchKeyword.value =
                                value.isNotEmpty ? value : null;
                            currentPage.value = 1;
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Cari nomor atau judul $jenisLabel...',
                            hintStyle: const TextStyle(
                                color: Color(0xFF9AA5B4), fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Year filter chips from API
          SizedBox(
            height: 46,
            child: tahunAsync.when(
              data: (years) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedTahun.value = null;
                        currentPage.value = 1;
                      },
                      child: _SmallChip(
                        label: 'Semua Tahun',
                        selected: selectedTahun.value == null,
                      ),
                    ),
                    ...years.map((year) {
                      final yearStr = year.toString();
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            selectedTahun.value = yearStr;
                            currentPage.value = 1;
                          },
                          child: _SmallChip(
                            label: yearStr,
                            selected: selectedTahun.value == yearStr,
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // Progress indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: dokumenAsync.when(
                data: (result) {
                  final pagination = result.pagination;
                  if (pagination?.total != null && pagination!.total! > 0) {
                    final totalPages =
                        (pagination.total! / (pagination.limit ?? 10)).ceil();
                    final progress = currentPage.value / totalPages;
                    return Row(
                      children: [
                        SizedBox(
                          width: 122,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: const Color(0xFFC7CCD3),
                            color: const Color(0xFF8D939C),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(999)),
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
                error: (_, __) => const SizedBox(),
              ),
            ),
          ),

          // Document list
          Expanded(
            child: dokumenAsync.when(
              data: (result) {
                final items = result.results;
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada dokumen ditemukan',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: JdihCard(
                        layout: CardLayout.vertical,
                        status: it.status,
                        category: it.jenis?.toUpperCase(),
                        title: it.judul ?? '',
                        date: it.tanggal,
                        onTap: () {
                          context.push("/jdih/detail", extra: {
                            "documentId": it.id
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
