import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/siskaperbapo/core/storage.dart';
import '../../../theme/app_theme.dart';
import '../../../../main/core/storage.dart';
import '../widgets/siskaperbapo_widgets.dart';
import '../../core/providers/skp_providers.dart';
import '../../domain/entities/bahan_pokok/skp_bahan_pokok_entity.dart';
import '../../domain/entities/area/skp_area_entity.dart';
import 'package:intl/intl.dart';

class SiskaperbapoScreen extends HookConsumerWidget {
  const SiskaperbapoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBahanPokok = useState<String>('Semua Bahan Pokok');
    final selectedArea = useState<String>('Semua Area');
    final selectedDate = useState<DateTime>(DateTime.now());

    final appliedBahanPokok = useState<String>('');
    final appliedArea = useState<String>('');
    final appliedDate = useState<DateTime>(DateTime.now());

    final allBahanPokokAsync = ref.watch(skpBahanPokokListProvider(
      tanggal: '',
      bahanPokok: '',
      area: '',
    ));

    final bahanPokokAsync = ref.watch(skpBahanPokokListProvider(
      tanggal: DateFormat('yyyy-MM-dd').format(appliedDate.value),
      bahanPokok: appliedBahanPokok.value,
      area: appliedArea.value,
    ));

    final areasAsync = ref.watch(skpAreasProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: CachedNetworkImage(
            imageUrl: 'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165394/Logo_Provinsi_Jawa_Timur_PNG-1080p_-_FileVector69_1_gwc0de.png',
            cacheManager: ref.watch(getCustomCacheManagerProvider),
            fit: BoxFit.contain,
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SISKAPERBAPO',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Sistem Informasi Ketersediaan dan Perkembangan\nHarga Bahan Pokok',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDescriptionCard(),
              const SizedBox(height: 16),
              OutlinedButton(
                  onPressed: () async {
                    await ref.read(skpClearIsarDbProvider.future);
                  },
                  child: Text("Reset ISAR")
              ),
              _buildFilterSection(
                context, 
                selectedBahanPokok, 
                selectedArea, 
                selectedDate, 
                allBahanPokokAsync, 
                areasAsync,
                () {
                  appliedBahanPokok.value = selectedBahanPokok.value == 'Semua Bahan Pokok' ? '' : selectedBahanPokok.value;
                  appliedArea.value = selectedArea.value == 'Semua Area' ? '' : selectedArea.value;
                  appliedDate.value = selectedDate.value;
                }
              ),
              const SizedBox(height: 24),
              bahanPokokAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(child: Text('Data tidak tersedia'));
                  }
                  return _buildItemsGrid(context, ref, data);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.jdihBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'SISKAPERBAPO, singkatan dari Sistem Informasi Ketersediaan dan Perkembangan Harga Bahan Pokok. Merupakan portal berbasis online yang menyajikan info tren harga dan ketersediaan bahan pokok harian dari seluruh area di Jawa Timur.',
        style: TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, 
      ValueNotifier<String> selectedBahanPokok, 
      ValueNotifier<String> selectedArea, 
      ValueNotifier<DateTime> selectedDate, 
      AsyncValue<List<SkpBahanPokokEntity>> allBahanPokokAsync, 
      AsyncValue<List<SkpAreaEntity>> areasAsync,
      VoidCallback onTampilkan) {
        
    List<String> areaList = ['Semua Area'];
    areasAsync.whenData((areas) {
      areaList.addAll(areas.map((e) => e.nama).toList());
    });
    
    List<String> bahanPokokList = ['Semua Bahan Pokok'];
    allBahanPokokAsync.whenData((data) {
      final names = data.map((e) => e.komoditas).toList();
      bahanPokokList.addAll(names);
    });

    final currentBahanPokok = bahanPokokList.contains(selectedBahanPokok.value) 
        ? selectedBahanPokok.value 
        : bahanPokokList.first;
        
    final currentArea = areaList.contains(selectedArea.value) 
        ? selectedArea.value 
        : areaList.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SiskaperbapoSelectInput(
            label: 'Jenis Bahan Pokok',
            value: currentBahanPokok,
            onTap: () {
              _showSelectionBottomSheet(
                context: context,
                title: 'Pilih Bahan Pokok',
                selectedValue: currentBahanPokok,
                items: bahanPokokList,
                onSelected: (val) {
                  selectedBahanPokok.value = val;
                },
              );
            },
          ),
          const SizedBox(height: 12),
          SiskaperbapoSelectInput(
            label: 'Area',
            value: currentArea,
            onTap: () {
              _showSelectionBottomSheet(
                context: context,
                title: 'Pilih Area',
                selectedValue: currentArea,
                items: areaList,
                onSelected: (val) {
                  selectedArea.value = val;
                },
              );
            },
          ),
          const SizedBox(height: 12),
          SiskaperbapoDatePicker(
            label: 'Tanggal',
            date: selectedDate.value,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate.value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null && picked != selectedDate.value) {
                selectedDate.value = picked;
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTampilkan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.jdihBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Tampilkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                ...items.map((item) {
                  final isSelected = item == selectedValue;
                  return ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.jdihBlue : Colors.black87,
                      ),
                    ),
                    trailing: isSelected 
                        ? const Icon(Icons.check, color: AppTheme.jdihBlue)
                        : null,
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildItemsGrid(BuildContext context, WidgetRef ref, List<SkpBahanPokokEntity> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildCommodityCard(context, ref, item);
      },
    );
  }

  Widget _buildCommodityCard(BuildContext context, WidgetRef ref, SkpBahanPokokEntity item) {
    return GestureDetector(
      onTap: () {
        context.push('/siskaperbapo/detail/${item.slug}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: item.gambarUrl,
                    cacheManager: ref.watch(getCustomCacheManagerProvider),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.image_outlined, size: 50, color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.komoditas,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(item.hargaSekarang),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      TrendIcon(trend: item.tren.toLowerCase() == 'naik' ? 'up' : (item.tren.toLowerCase() == 'turun' ? 'down' : 'flat')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

