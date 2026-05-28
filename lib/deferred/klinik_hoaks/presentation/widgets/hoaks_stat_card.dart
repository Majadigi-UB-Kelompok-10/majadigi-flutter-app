import 'package:flutter/material.dart';

class HoaksStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  const HoaksStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
