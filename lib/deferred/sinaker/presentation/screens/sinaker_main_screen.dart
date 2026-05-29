import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import '../../core/providers/snk_providers.dart';
import '../../domain/entities/blk/snk_blk_entity.dart';

class SinakerMainScreen extends HookConsumerWidget {
  const SinakerMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blkListAsync = ref.watch(snkBlkListProvider);
    final kotaListAsync = ref.watch(snkKotaListProvider);
    final selectedCity = useState<String?>(null);

    return Scaffold(
      backgroundColor: const Color(0xFF003B8D),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF003B8D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: CachedNetworkImage(
            imageUrl: "https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165241/Sinaker_Logo_km6ql8.png",
            height: 30,
            fit: BoxFit.contain,
            useOldImageOnUrlChange: true,
            cacheManager: ref.watch(getCustomCacheManagerProvider),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'LAYANAN DIGITAL KETENAGAKERJAAN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sinaker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Akses layanan ketenagakerjaan terintegrasi dari\nDisnakertrans Jawa Timur. Pendaftaran kerja,\npelatihan vokasi, dan sertifikasi dalam satu pintu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: _buildCityDropdown(kotaListAsync, selectedCity),
              ),
              const SizedBox(height: 24),
              _buildBodyContent(context, blkListAsync, selectedCity.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown(
    AsyncValue<List<String>> kotaListAsync,
    ValueNotifier<String?> selectedCity,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: kotaListAsync.when(
        data: (kotaList) {
          final options = ['Semua Kota / Kabupaten', ...kotaList];
          final currentValue = selectedCity.value != null && options.contains(selectedCity.value)
              ? selectedCity.value
              : options.first;

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentValue,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  selectedCity.value = newValue == 'Semua Kota / Kabupaten' ? null : newValue;
                }
              },
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )),
        ),
        error: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Gagal memuat kota', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    AsyncValue<List<SnkBlkEntity>> blkListAsync,
    String? selectedCity,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: blkListAsync.when(
        data: (blkList) {
          final filteredBlks = selectedCity == null
              ? blkList
              : blkList.where((blk) =>
                  blk.kabKota.toLowerCase().contains(selectedCity.toLowerCase()),
                ).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Balai Latihan Kerja',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'UPT Disnakertrans Provinsi Jawa Timur',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${filteredBlks.length} LOKASI AKTIF',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (filteredBlks.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Data Tidak Ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
              LayoutBuilder(
                builder: (context, constraints) {
                  final double itemWidth = (constraints.maxWidth - 16) / 2;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: filteredBlks.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: _buildBlkCard(context, item),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 40),
              _buildFooter(),
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'Gagal memuat data BLK',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlkCard(BuildContext context, SnkBlkEntity blk) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance,
              color: Colors.blue.shade800,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'UPT BLK',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            blk.nama,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            blk.alamat,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {
                    context.push("/balai-latihan-kerja/daftar", extra: {
                      "blkId": blk.id,
                      "blkName": blk.nama
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    context.push("/cek-pendaftaran-pelatihan-kerja");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cek Status',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.blue.shade800,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Icon(
            Icons.business,
            size: 40,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'DISNAKERTRANS JAWA TIMUR',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '© 2024. SELURUH HAK CIPTA DILINDUNGI.',
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade400,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
