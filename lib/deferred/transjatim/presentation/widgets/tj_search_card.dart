import 'package:flutter/material.dart';

class TjSearchCard extends StatelessWidget {
  const TjSearchCard({
    super.key,
    required this.busCode,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.originCity,
    required this.originTerminal,
    required this.destinationCity,
    required this.destinationTerminal,
    required this.duration,
    this.onTap,
  });

  final String busCode;
  final String price;
  final String departureTime;
  final String arrivalTime;
  final String originCity;
  final String originTerminal;
  final String destinationCity;
  final String destinationTerminal;
  final String duration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                      busCode,
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
                  'Rp. $price',
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
                child: _RouteSide(
                  time: departureTime,
                  city: originCity,
                  terminal: originTerminal,
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
                        duration,
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
                child: _RouteSide(
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
      )
    );
  }
}


class _RouteSide extends StatelessWidget {
  const _RouteSide({
    required this.time,
    required this.city,
    required this.terminal,
    required this.alignEnd,
  });

  final String time;
  final String city;
  final String terminal;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = alignEnd ? TextAlign.right : TextAlign.left;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          textAlign: textAlign,
          style: const TextStyle(fontSize: 11, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          terminal,
          textAlign: textAlign,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}
