import 'package:flutter/material.dart';
import 'tj_route_info.dart';

/// Card displaying bus code, service type, departure/arrival info, and duration.
class TjBusInfoCard extends StatelessWidget {
  final String busKode;
  final String busLayanan;
  final String departureTime;
  final String arrivalTime;
  final String originCity;
  final String originTerminal;
  final String destinationCity;
  final String destinationTerminal;
  final String duration;

  const TjBusInfoCard({
    super.key,
    required this.busKode,
    required this.busLayanan,
    required this.departureTime,
    required this.arrivalTime,
    required this.originCity,
    required this.originTerminal,
    required this.destinationCity,
    required this.destinationTerminal,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // Bus code + service type row
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
                      busKode,
                      style: const TextStyle(color: Color(0xFF123C8C), fontWeight: FontWeight.w700, fontSize: 13),
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
                  busLayanan,
                  style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Route info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TjRouteInfo(
                  time: departureTime,
                  city: originCity,
                  terminal: originTerminal,
                  alignEnd: false,
                ),
              ),
              _DurationBadge(duration: duration),
              Expanded(
                child: TjRouteInfo(
                  time: arrivalTime,
                  city: destinationCity,
                  terminal: destinationTerminal,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small badge showing travel duration between two dashed lines.
class _DurationBadge extends StatelessWidget {
  final String duration;
  const _DurationBadge({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(width: 16, height: 2, color: const Color(0xFFBFD0FF)),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF5B8CFF)),
            ),
            child: Text(
              duration,
              style: const TextStyle(color: Color(0xFF5B8CFF), fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 4),
          Container(width: 16, height: 2, color: const Color(0xFFBFD0FF)),
        ],
      ),
    );
  }
}
