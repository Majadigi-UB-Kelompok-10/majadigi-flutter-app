import 'package:flutter/material.dart';

class TjRouteInfo extends StatelessWidget {
  final String time;
  final String city;
  final String terminal;
  final bool alignEnd;

  const TjRouteInfo({
    super.key,
    required this.time,
    required this.city,
    required this.terminal,
    this.alignEnd = false,
  });

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
