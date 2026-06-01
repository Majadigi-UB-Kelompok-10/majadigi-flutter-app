import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A map point to be displayed as a marker on the map.
class SiditaMapPoint {
  final double lat;
  final double lng;
  final String? nama;
  final String? thumbnailUrl;

  const SiditaMapPoint({
    required this.lat,
    required this.lng,
    this.nama,
    this.thumbnailUrl,
  });
}

/// Reusable map widget for SIDITA — renders markers on OpenStreetMap tiles.
///
/// Used for:
/// - Distribution maps (destination list, hotel list) — multiple markers
/// - Detail screens — single marker at the entity's coordinates
class SiditaMapView extends StatefulWidget {
  /// Center latitude of the map.
  final double centerLat;

  /// Center longitude of the map.
  final double centerLng;

  /// Initial zoom level.
  final double zoom;

  /// List of points to render as markers.
  final List<SiditaMapPoint> points;

  /// Height of the map container.
  final double height;

  const SiditaMapView({
    super.key,
    this.centerLat = -7.6979,
    this.centerLng = 112.4939,
    this.zoom = 8.0,
    this.points = const [],
    this.height = 300,
  });

  @override
  State<SiditaMapView> createState() => _SiditaMapViewState();
}

class _SiditaMapViewState extends State<SiditaMapView> {
  late final MapController _mapController;
  int? _selectedMarkerIndex;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(widget.centerLat, widget.centerLng),
                initialZoom: widget.zoom,
                onTap: (_, _) {
                  if (_selectedMarkerIndex != null) {
                    setState(() => _selectedMarkerIndex = null);
                  }
                },
              ),
              children: [
                // Tiles
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.majadigi.mobile.rebuild.app',
                ),

                // Markers
                MarkerLayer(
                  markers: widget.points.asMap().entries.map((entry) {
                    final index = entry.key;
                    final point = entry.value;
                    final isSelected = _selectedMarkerIndex == index;

                    return Marker(
                      point: LatLng(point.lat, point.lng),
                      width: isSelected ? 200 : 40,
                      height: isSelected ? 80 : 40,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMarkerIndex = isSelected ? null : index;
                          });
                        },
                        child: isSelected
                            ? _buildPopupMarker(point)
                            : const Icon(
                                Icons.location_on,
                                color: Color(0xFF0F3B8C),
                                size: 36,
                              ),
                      ),
                    );
                  }).toList(),
                ),

                // Attribution
                SimpleAttributionWidget(
                  source: Text(
                    "OpenStreetMap",
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),

            // Zoom Controls
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildZoomButton(
                    icon: Icons.add,
                    heroTag: 'sd_zoom_in',
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      final center = _mapController.camera.center;
                      _mapController.move(center, currentZoom + 1);
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildZoomButton(
                    icon: Icons.remove,
                    heroTag: 'sd_zoom_out',
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      final center = _mapController.camera.center;
                      _mapController.move(center, currentZoom - 1);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMarker(SiditaMapPoint point) {
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
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (point.thumbnailUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    point.thumbnailUrl!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 36,
                      height: 36,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 16, color: Colors.grey),
                    ),
                  ),
                ),
              if (point.thumbnailUrl != null) const SizedBox(width: 6),
              Flexible(
                child: Text(
                  point.nama ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F3B8C),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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

  Widget _buildZoomButton({
    required IconData icon,
    required String heroTag,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: FloatingActionButton(
        heroTag: heroTag,
        backgroundColor: Colors.white,
        mini: true,
        onPressed: onPressed,
        child: Icon(icon, color: Colors.black87, size: 18),
      ),
    );
  }
}
