import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../core/providers/bpd_providers.dart';
import '../../domain/entities/njkb/bpd_njkb_entity.dart';
import '../widgets/bapenda_sell_form.dart';
import '../widgets/bapenda_sell_search_result.dart';

class BapendaSellScreen extends HookConsumerWidget {
  const BapendaSellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final isLoading = useState(false);
    final searchResult = useState<BpdNjkbKalkulasiEntity?>(null);
    final error = useState<String?>(null);

    Future<void> handleSearch({
      required String jenis,
      required String merk,
      required String model,
      required String tipe,
      required int tahun,
    }) async {
      isLoading.value = true;
      error.value = null;
      searchResult.value = null;

      try {
        final useCase = ref.read(bpdPostKalkulasiProvider);
        final result = await useCase.execute(
          jenis: jenis,
          merk: merk,
          model: model,
          tipe: tipe,
          tahun: tahun,
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
        error.value = 'Gagal menghitung. Silakan coba lagi.';
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
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 175,
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
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Cek Nilai Jual',
                        style: TextStyle(
                          fontSize: 42,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.jdihBlue,
                        ),
                      ),
                      Text(
                        'Kendaraan',
                        style: TextStyle(
                          fontSize: 42,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF15803D),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Lengkapi detail kendaraan Anda untuk mendapatkan estimasi nilai jual terkini dari referensi resmi Bapenda Jawa Timur.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF56667E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                BapendaSellForm(onSearch: handleSearch),
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
                          'Mencari estimasi nilai jual...',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                if (searchResult.value != null) ...[
                  const SizedBox(height: 18),
                  BapendaSellSearchResult(
                    result: searchResult.value!,
                    onClose: closeResult,
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFFE8ECF2)),
                const SizedBox(height: 16),
                const Text(
                  '© 2024 Badan Pendapatan Daerah Jawa Timur.',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF687588),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Layanan Digital Perpajakan Terpadu. Seluruh hak cipta dilindungi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF98A2B0),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
