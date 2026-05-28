import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/core/providers/tj_providers.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';

import '../widgets/tj_route_stop_item.dart';
import '../widgets/tj_bus_info_card.dart';
import '../widgets/tj_map_preview.dart';

/// Screen showing detailed schedule information with map and route stops.
class TjDetailScreen extends ConsumerWidget {
  final TjSearchEntity search;
  final String fromTerminal;
  final String toTerminal;

  const TjDetailScreen({
    super.key,
    required this.search,
    required this.fromTerminal,
    required this.toTerminal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(tjScheduleDetailProvider(search.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '$fromTerminal - $toTerminal',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: detailAsync.when(
        data: (schedule) {
          if (schedule == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }
          return _DetailContent(
            schedule: schedule,
            search: search,
            fromTerminal: fromTerminal,
            toTerminal: toTerminal,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Gagal memuat detail jadwal')),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail content body
// ---------------------------------------------------------------------------

class _DetailContent extends StatelessWidget {
  final TjScheduleEntity schedule;
  final TjSearchEntity search;
  final String fromTerminal;
  final String toTerminal;

  const _DetailContent({
    required this.schedule,
    required this.search,
    required this.fromTerminal,
    required this.toTerminal,
  });

  String _calculateDuration(TjSearchEntity schedule) {
    final departureTime = schedule.departureTime ?? '00:00';
    final arrivalTime = schedule.arrivalTime ?? '00:00';

    DateFormat format = DateFormat("HH:mm");
    DateTime departure = format.parse(departureTime);
    DateTime arrival = format.parse(arrivalTime);

    Duration difference = arrival.difference(departure);
    int hour = difference.inHours;
    int minutes = difference.inMinutes % 60;

    return "${hour}J ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Map
          TjMapPreview(
            stops: schedule.stops ?? [
              schedule.terminalAsal ?? fromTerminal,
              schedule.terminalTujuan ?? toTerminal,
            ],
            originLatitude: search.originLatitude,
            originLongitude: search.originLongitude,
            destinationLatitude: search.destinationLatitude,
            destinationLongitude: search.destinationLongitude,
          ),

          // Bus info card
          Padding(
            padding: const EdgeInsets.all(16),
            child: TjBusInfoCard(
              busKode: schedule.busKode ?? '',
              busLayanan: (schedule.busLayanan ?? '').toUpperCase(),
              departureTime: schedule.jamBerangkat ?? '',
              arrivalTime: schedule.jamTiba ?? '',
              originCity: search.originCity ?? '',
              originTerminal: schedule.terminalAsal ?? '',
              destinationCity: search.destinationCity ?? '',
              destinationTerminal: schedule.terminalTujuan ?? '',
              duration: _calculateDuration(search),
            ),
          ),

          // Route detail
          _RouteDetailSection(
            schedule: schedule,
            fromTerminal: fromTerminal,
            toTerminal: toTerminal,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Route detail section with stops
// ---------------------------------------------------------------------------

class _RouteDetailSection extends StatelessWidget {
  final TjScheduleEntity schedule;
  final String fromTerminal;
  final String toTerminal;

  const _RouteDetailSection({
    required this.schedule,
    required this.fromTerminal,
    required this.toTerminal,
  });

  @override
  Widget build(BuildContext context) {
    // Build stop list from schedule.stops, fallback to origin/destination
    final stops = schedule.stops ?? [
      schedule.terminalAsal ?? fromTerminal,
      schedule.terminalTujuan ?? toTerminal,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, size: 20, color: AppTheme.jdihBlue),
              const SizedBox(width: 8),
              const Text(
                'Detail Rute',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < stops.length; i++)
                  TjRouteStopItem(
                    name: stops[i],
                    isLast: i == stops.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
