import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';

/// Map preview widget showing a route between two geo points.
class TjMapPreview extends HookWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  const TjMapPreview({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

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
      },
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
                unFollowUser: false,
              ),
              showZoomController: true,
              zoomOption: ZoomOption(
                initZoom: 15,
                maxZoomLevel: 19,
                minZoomLevel: 8,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(Icons.location_history_rounded, color: Colors.red, size: 48),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(Icons.double_arrow, size: 48),
                ),
              ),
              roadConfiguration: const RoadOption(roadColor: Colors.yellowAccent),
            ),
          ),
          // Location button
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () async {
                await mapController.currentLocation();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
                  ],
                ),
                child: const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
