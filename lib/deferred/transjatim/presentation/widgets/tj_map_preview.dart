import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/schedule/tj_schedule_entity.dart';

/// Map preview widget
/// Render Based on Stops and Route Coordinates
/// Uses Flutter_Map with caching built-in (since 8.2.0)
class TjMapPreview extends HookConsumerWidget {
  final List<TjStopEntity>? stops;
  final List<List<double>>? routeCoordinates;
  final double? originLatitude;
  final double? originLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  const TjMapPreview({
    super.key,
    this.stops,
    this.routeCoordinates,
    this.originLatitude,
    this.originLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map Controller
    final mapController = useMemoized(() => MapController());
    final selectedMarkerIndex = useState<int?>(null);

    // Determine initial center
    final initialCenter = useMemoized(() {
      if (originLatitude != null && originLongitude != null) {
        return LatLng(originLatitude!, originLongitude!);
      } else if (stops != null && stops!.isNotEmpty && stops!.first.lat != null && stops!.first.lng != null) {
        return LatLng(stops!.first.lat!, stops!.first.lng!);
      }
      return const LatLng(-7.9826, 112.6308); // Fallback: Malang center
    });

    // Parse Polyline Points
    final polylinePoints = useMemoized(() {
      if (routeCoordinates == null) return <LatLng>[];
      return routeCoordinates!
          .where((coord) => coord.length == 2)
          .map((coord) => LatLng(coord[1], coord[0])) // JSON usually [lng, lat]
          .toList();
    }, [routeCoordinates]);

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Map itself
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
              onTap: (_, __) {
                if (selectedMarkerIndex.value != null) {
                  selectedMarkerIndex.value = null;
                }
              },
            ),
            children: [
              // 1. The Map Tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.majadigi.mobile.rebuild.app',
              ),

              // 2. Draw the Route Path (If available)
              if (polylinePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      color: Colors.blueAccent,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),

              // 3. Draw the Place Markers (Stops)
              if (stops != null)
                MarkerLayer(
                  markers: stops!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stop = entry.value;
                    final isSelected = selectedMarkerIndex.value == index;

                    if (stop.lat == null || stop.lng == null) {
                      // Fallback to empty marker if coordinates are invalid
                      return Marker(
                        point: const LatLng(0, 0),
                        width: 0,
                        height: 0,
                        child: const SizedBox(),
                      );
                    }

                    return Marker(
                      point: LatLng(stop.lat!, stop.lng!),
                      width: isSelected ? 200 : 40,
                      height: isSelected ? 80 : 40,
                      child: GestureDetector(
                        onTap: () {
                          selectedMarkerIndex.value = isSelected ? null : index;
                        },
                        child: isSelected
                            ? _buildPopupMarker(stop)
                            : const Icon(
                          Icons.location_on,
                          color: Color(0xFF0F3B8C), // AppTheme.jdihBlue approximation
                          size: 36,
                        ),
                      ),
                    );
                  }).where((m) => m.width > 0).toList(),
                ),

              // 4. GPS Capability (Tracks user's live location seamlessly)
              CurrentLocationLayer(
                alignPositionOnUpdate: AlignOnUpdate.never,
                alignDirectionOnUpdate: AlignOnUpdate.never,
              ),

              // Attribution
              const SimpleAttributionWidget(
                alignment: Alignment.topLeft,
                source: Text("OpenStreetMap Contributors"),
              ),
            ],
          ),

          // Location button
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'tj_location_btn',
              backgroundColor: Colors.white,
              onPressed: () async {
                try {
                  // Fetch the current physical location
                  final position = await Geolocator.getCurrentPosition(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.high,
                    ),
                  );
                  // Move the map camera to the user's location
                  mapController.move(
                    LatLng(position.latitude, position.longitude),
                    13.0, // Zoom level when centered
                  );
                } catch (e) {
                  // Handle location permissions denied scenario
                  debugPrint("Location access denied: \$e");
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // 4. Zoom Controls (Bottom Right)
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'tj_zoom_in_btn',
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {
                    final currentZoom = mapController.camera.zoom;
                    final center = mapController.camera.center;
                    mapController.move(center, currentZoom + 1);
                  },
                  child: const Icon(Icons.add, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'tj_zoom_out_btn',
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {
                    final currentZoom = mapController.camera.zoom;
                    final center = mapController.camera.center;
                    mapController.move(center, currentZoom - 1);
                  },
                  child: const Icon(Icons.remove, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMarker(TjStopEntity stop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Flexible(
            child: Text(
              stop.nama ?? 'Halte',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F3B8C),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Icon(
          Icons.location_on,
          color: Color(0xFF0F3B8C),
          size: 28,
        ),
      ],
    );
  }
}
