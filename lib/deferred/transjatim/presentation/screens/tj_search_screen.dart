import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/core/providers/tj_providers.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import '../widgets/tj_search_card.dart';

class TjSearchScreen extends ConsumerWidget {
  final String fromTerminalId;
  final String toTerminalId;
  final String fromTerminal;
  final String toTerminal;
  final String date;

  const TjSearchScreen({
    super.key,
    required this.fromTerminalId,
    required this.toTerminalId,
    required this.fromTerminal,
    required this.toTerminal,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(
      tjSearchSchedulesProvider(fromTerminalId, toTerminalId, fromTerminal, toTerminal, date),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$fromTerminal - $toTerminal',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: searchAsync.when(
        data: (results) => _buildResultsList(context, results),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Gagal memuat data jadwal'),
        ),
      ),
    );
  }

  Widget _buildResultsList(
    BuildContext context,
    List<TjSearchEntity> results,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter & Sort Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${results.length} Hasil ditemukan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Results List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return TjSearchCard(
                  busCode: result.busKode ?? '',
                  price: _formatPrice(result.price),
                  departureTime: result.departureTime ?? '',
                  arrivalTime: result.arrivalTime ?? '',
                  originCity: result.originCity ?? '',
                  originTerminal: result.originTerminal ?? '',
                  destinationCity: result.destinationCity ?? '',
                  destinationTerminal: result.destinationTerminal ?? '',
                  duration: _calculateDuration(result),
                  onTap: () => _goToDetail(context, result),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double? price) {
    final nonNullPrice = price ?? 0;

    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(nonNullPrice);
  }

  String _calculateDuration(TjSearchEntity schedule) {
    // Format is HH:mm
    final departureTime = schedule.departureTime ?? '00:00';
    final arrivalTime = schedule.arrivalTime ?? '00:00';

    // Parse using Intl package
    DateFormat format = DateFormat("HH:mm");
    DateTime departure = format.parse(departureTime);
    DateTime arrival = format.parse(arrivalTime);

    // Get Difference
    Duration difference = arrival.difference(departure);
    int hour = difference.inHours;
    int minutes = difference.inMinutes % 60;

    return "${hour}J ${minutes}m";
  }

  void _goToDetail(BuildContext context, TjSearchEntity schedule) {
    context.push(
      '/transjatim/detail',
      extra: {
        'schedule': schedule,
        'fromTerminal': fromTerminal,
        'toTerminal': toTerminal,
      },
    );
  }
}
