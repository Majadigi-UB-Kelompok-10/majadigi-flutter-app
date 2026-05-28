import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Map preview widget
/// Render Based on Stops
/// Uses Flutter_Map with caching built-in (since 8.2.0)
class TjMapPreview extends HookConsumerWidget {
  final List<String>? stops;
  final double? originLatitude;
  final double? originLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  const TjMapPreview({
    super.key,
    this.stops,
    this.originLatitude,
    this.originLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map Controller
    final mapController = useMemoized(() => MapController());

    // Coordinate
    final startPoint = useMemoized(() => LatLng(originLatitude ?? -7.9826, originLongitude ?? 112.6308));
    final endPoint = useMemoized(() => LatLng(destinationLatitude ?? -7.8718, destinationLongitude ?? 112.5255));

    return Stack(
      children: [
        // Map itself
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: startPoint,
            initialZoom: 13.0,
          ),
          children: [
            // 1. The Map Tiles (With Caching enabled)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.majadigi.mobile.rebuild.app',
            ),

            // 2. Draw the Route Path (If available)
            // routeAsync.when(
            //   data: (routePoints) => PolylineLayer(
            //     polylines: [
            //       Polyline(
            //         points: routePoints,
            //         color: Colors.blueAccent,
            //         strokeWidth: 5.0,
            //       ),
            //     ],
            //   ),
            //   loading: () => const SizedBox.shrink(), // Or a loading indicator overlay
            //   error: (err, stack) => const SizedBox.shrink(),
            // ),

            // 3. Draw the Place Markers
            MarkerLayer(
              markers: [
                Marker(
                  point: startPoint,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
                Marker(
                  point: endPoint,
                  child: const Icon(Icons.flag, color: Colors.green, size: 40),
                ),
              ],
            ),

            // 4. GPS Capability (Tracks user's live location seamlessly)
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.never,
              alignDirectionOnUpdate: AlignOnUpdate.never,
            ),
            
            // Attribution
            SimpleAttributionWidget(source: Text("flutter_map | OpenStreetMap Contributors")),
          ],
        ),

        // Location button
        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton(
            heroTag: 'location_btn',
            backgroundColor: Colors.white,
            onPressed: () async {
              try {
                // Fetch the current physical location
                final position = await Geolocator.getCurrentPosition(
                  locationSettings: LocationSettings(
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
                debugPrint("Location access denied: $e");
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
                heroTag: 'zoom_in_btn',
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
                heroTag: 'zoom_out_btn',
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
    );
  }
}
