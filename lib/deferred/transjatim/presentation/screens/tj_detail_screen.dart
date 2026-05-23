import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/core/providers/tj_providers.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';
import '../widgets/tj_route_info.dart';
import '../widgets/tj_route_stop_item.dart';

class TjDetailScreen extends HookConsumerWidget {
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
    final detailAsync = ref.watch(tjScheduleDetailProvider(search.id!));

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
          return _buildDetailContent(context, schedule, search);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Gagal memuat detail jadwal'),
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, TjScheduleEntity schedule, TjSearchEntity search) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Map Section
          _MapPreview(
            initialLatitude: search.originLatitude ?? -7,
            initialLongitude: search.originLongitude ?? 112,
            destinationLatitude: search.destinationLatitude ?? -8,
            destinationLongitude: search.destinationLongitude ?? 113,
          ),

          // Bus Info Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus, size: 18, color: Color(0xFF123C8C)),
                            const SizedBox(width: 6),
                            Text(
                              schedule.busKode ?? '',
                              style: const TextStyle(
                                color: Color(0xFF123C8C),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2E7D32)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          (schedule.busLayanan ?? '').toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TjRouteInfo(
                          time: schedule.jamBerangkat ?? '',
                          city: search.originCity ?? '',
                          terminal: schedule.terminalAsal ?? '',
                          alignEnd: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 2,
                              color: const Color(0xFFBFD0FF),
                            ),
                            SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F8FF),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: const Color(0xFF5B8CFF)),
                              ),
                              child: Text(
                                _calculateDuration(search),
                                style: const TextStyle(
                                  color: Color(0xFF5B8CFF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 16,
                              height: 2,
                              color: const Color(0xFFBFD0FF),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TjRouteInfo(
                          time: schedule.jamTiba ?? '',
                          city: search.destinationCity ?? '',
                          terminal: schedule.terminalTujuan ?? '',
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Detail Rute Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.route,
                          size: 20,
                          color: AppTheme.jdihBlue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Detail Rute',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
                      TjRouteStopItem(
                        name: schedule.terminalAsal ?? fromTerminal,
                        isLast: false,
                      ),
                      TjRouteStopItem(
                        name: schedule.terminalTujuan ?? toTerminal,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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
}

class _MapPreview extends HookWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  const _MapPreview({required this.initialLatitude, required this.initialLongitude, required this.destinationLatitude, required this.destinationLongitude});

  @override
  Widget build(BuildContext context) {
    final mapController = useMapController(
      initPosition: GeoPoint(latitude: initialLatitude, longitude: initialLongitude),
    );

    void drawBusRoute() async {
      GeoPoint startPoint = GeoPoint(latitude: initialLatitude, longitude: initialLongitude);
      GeoPoint endPoint = GeoPoint(latitude: destinationLatitude, longitude: destinationLongitude);

      await mapController.drawRoad(
        startPoint,
        endPoint,
        roadType: RoadType.car,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: Colors.blue,
          zoomInto: true,
        ),
      );
    }

    useMapIsReady(
        controller: mapController,
        mapIsReady: () {
          drawBusRoute();
        }
    );

    return Container(
      height: 280,
      width: double.infinity,
      color: Colors.grey[200],
      child: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                  enableTracking: false,
                  unFollowUser: false
              ),
              showZoomController: true,
              zoomOption: ZoomOption(
                initZoom: 15,
                maxZoomLevel: 19,
                minZoomLevel: 8,
                stepZoom: 1.0
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
            )
          ),

          // Location button
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () async {await mapController.currentLocation();},
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)
                  ],
                ),
                child: const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
              ),
            )
          ),
        ],
      ),
    );
  }
}
