import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../core/providers/bpd_providers.dart';
import '../../domain/entities/pajak/bpd_pajak_entity.dart';
import '../widgets/bapenda_pajak_form.dart';
import '../widgets/bapenda_tax_search_result.dart';

class BapendaTaxScreen extends HookConsumerWidget {
  const BapendaTaxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final isLoading = useState(false);
    final searchResult = useState<BpdPajakEntity?>(null);
    final error = useState<String?>(null);

    Future<void> handleSearch(String platNomor, String nomorRangka) async {
      isLoading.value = true;
      error.value = null;
      searchResult.value = null;

      try {
        final useCase = ref.read(bpdGetPajakInfoProvider);
        final result = await useCase.execute(
          platNomor: platNomor,
          nomorRangka: nomorRangka,
        );
        searchResult.value = result;

        await Future.delayed(const Duration(milliseconds: 120));
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        error.value = 'Gagal mengambil data. Silakan coba lagi. ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    void closeResult() {
      searchResult.value = null;
      error.value = null;
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 190,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0061FF),
                      Color(0xFF00A859),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Informasi Pajak',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A8A),
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Kendaraan\nBermotor',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF15803D),
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Akses data perpajakan kendaraan Anda secara transparan dan instan melalui sistem terintegrasi pemerintah Jawa Timur.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                BapendaPajakForm(
                  onSearch: handleSearch,
                ),
                if (error.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              error.value!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isLoading.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppTheme.jdihBlue),
                        SizedBox(height: 10),
                        Text(
                          'Mencari data kendaraan...',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                if (searchResult.value != null)
                  BapendaTaxSearchResult(
                    result: searchResult.value!,
                    onClose: closeResult,
                  ),
                const SizedBox(height: 40),
                const Center(
                  child: Column(
                    children: [
                      Text(
                        '© 2024 Badan Pendapatan Daerah Jawa Timur.',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Layanan Digital Perpajakan Terpadu. Seluruh hak cipta dilindungi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}