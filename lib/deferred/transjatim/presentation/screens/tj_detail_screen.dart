import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import '../../data/models/bus_detail.dart';
import '../widgets/tj_route_info.dart';
import '../widgets/tj_route_stop_item.dart';

class TjDetailScreen extends StatefulWidget {
  final BusDetailData busDetail;

  const TjDetailScreen({
    super.key,
    required this.busDetail,
  });

  @override
  State<TjDetailScreen> createState() => _TjDetailScreenState();
}

class _TjDetailScreenState extends State<TjDetailScreen> {
  bool _expandedRoute = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.busDetail.originCity} - ${widget.busDetail.destinationCity}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Section
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  // Placeholder Map - Replace dengan google_maps_flutter nanti
                  Container(
                    color: const Color(0xFFE8F5E9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map, size: 60, color: Colors.green),
                          const SizedBox(height: 12),
                          Text(
                            'Rute: ${widget.busDetail.originCity} → ${widget.busDetail.destinationCity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Location button
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
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
                                widget.busDetail.busCode,
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
                            'Rp. ${widget.busDetail.price}',
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
                            time: widget.busDetail.departureTime,
                            city: widget.busDetail.originCity,
                            terminal: widget.busDetail.originTerminal,
                            alignEnd: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F8FF),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: const Color(0xFF5B8CFF)),
                                ),
                                child: Text(
                                  widget.busDetail.duration,
                                  style: const TextStyle(
                                    color: Color(0xFF5B8CFF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 1,
                                color: const Color(0xFFBFD0FF),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TjRouteInfo(
                            time: widget.busDetail.arrivalTime,
                            city: widget.busDetail.destinationCity,
                            terminal: widget.busDetail.destinationTerminal,
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
                  GestureDetector(
                    onTap: () => setState(() => _expandedRoute = !_expandedRoute),
                    child: Row(
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
                        Icon(
                          _expandedRoute ? Icons.expand_less : Icons.expand_more,
                          color: AppTheme.jdihBlue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_expandedRoute)
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
                          ...List.generate(widget.busDetail.routeStops.length, (index) {
                            final stop = widget.busDetail.routeStops[index];
                            final isLast = index == widget.busDetail.routeStops.length - 1;
                            return TjRouteStopItem(
                              name: stop.name,
                              isLast: isLast,
                            );
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
