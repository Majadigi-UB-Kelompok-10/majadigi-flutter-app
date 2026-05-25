import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../../../main/core/storage.dart';
import '../widgets/siskaperbapo_widgets.dart';
import '../../core/providers/skp_providers.dart';
import '../../domain/entities/bahan_pokok/skp_detail_bahan_pokok_entity.dart';

class SiskaperbapoDetailScreen extends HookConsumerWidget {
  final String slug;

  const SiskaperbapoDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(skpDetailBahanPokokProvider(slug: slug));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SISKAPERBAPO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sistem Informasi Ketersediaan dan Perkembangan\nHarga Bahan Pokok',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      body: detailAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(context, ref, item),
                  const SizedBox(height: 24),
                  const Text(
                    'Grafik Harga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildChartCard(item),
                  const SizedBox(height: 24),
                  const Text(
                    'Harga di kab/kota',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildRegencyList(item),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, WidgetRef ref, SkpDetailBahanPokokEntity item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: item.gambarUrl,
                    cacheManager: ref.watch(getCustomCacheManagerProvider),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadge(item),
                    const SizedBox(height: 8),
                    Text(
                      item.komoditas,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(item.hargaUtama),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          _buildExtremesRow(
            'Harga rata-rata tertinggi',
            item.statistik.tertinggi.area,
            item.statistik.tertinggi.harga,
            'up',
          ),
          const SizedBox(height: 12),
          _buildExtremesRow(
            'Harga rata-rata terendah',
            item.statistik.terendah.area,
            item.statistik.terendah.harga,
            'down',
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(SkpDetailBahanPokokEntity item) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;
    String trendStr = item.tren.toLowerCase();

    if (trendStr == 'naik' || trendStr == 'up') {
      bgColor = Colors.pink.shade50;
      textColor = Colors.red;
      text = 'Harga Naik';
      icon = Icons.trending_up;
    } else if (trendStr == 'turun' || trendStr == 'down') {
      bgColor = Colors.green.shade50;
      textColor = Colors.green;
      text = 'Harga Turun';
      icon = Icons.trending_down;
    } else {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange;
      text = 'Harga Stabil';
      icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Icon(icon, color: textColor, size: 12),
        ],
      ),
    );
  }

  Widget _buildExtremesRow(String title, String regency, double price, String trend) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87)),
            Text(regency, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
        Row(
          children: [
            TrendIcon(trend: trend),
            const SizedBox(width: 8),
            Text(
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price),
              style: TextStyle(
                fontSize: 12,
                color: trend == 'up' ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard(SkpDetailBahanPokokEntity item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Harga',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.jdihBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet, color: AppTheme.jdihBlue, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: item.grafikRiwayat.isEmpty
                ? const Center(child: Text('Data tidak tersedia', style: TextStyle(color: Colors.grey)))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 500,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < item.grafikRiwayat.length) {
                                // show every few labels to prevent overlap
                                if (value.toInt() % 3 == 0 || value.toInt() == item.grafikRiwayat.length - 1) {
                                  final dateStr = item.grafikRiwayat[value.toInt()].tanggal;
                                  try {
                                    final date = DateTime.parse(dateStr);
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '${date.day}/${date.month}/${date.year}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 8),
                                      ),
                                    );
                                  } catch (_) {
                                    return const Text('');
                                  }
                                }
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 500,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(value),
                                style: const TextStyle(color: Colors.grey, fontSize: 8),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (item.grafikRiwayat.length - 1).toDouble(),
                      minY: _getMinPrice(item),
                      maxY: _getMaxPrice(item),
                      lineBarsData: [
                        LineChartBarData(
                          spots: item.grafikRiwayat.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.rataRataHarga);
                          }).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  double _getMinPrice(SkpDetailBahanPokokEntity item) {
    if (item.grafikRiwayat.isEmpty) return 0;
    double min = item.grafikRiwayat.first.rataRataHarga;
    for (var h in item.grafikRiwayat) {
      if (h.rataRataHarga < min) min = h.rataRataHarga;
    }
    return min - 500; // Add padding
  }

  double _getMaxPrice(SkpDetailBahanPokokEntity item) {
    if (item.grafikRiwayat.isEmpty) return 100;
    double max = item.grafikRiwayat.first.rataRataHarga;
    for (var h in item.grafikRiwayat) {
      if (h.rataRataHarga > max) max = h.rataRataHarga;
    }
    return max + 500; // Add padding
  }

  Widget _buildRegencyList(SkpDetailBahanPokokEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: item.listKabKota.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final regency = item.listKabKota[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  regency.area,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(regency.harga),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
