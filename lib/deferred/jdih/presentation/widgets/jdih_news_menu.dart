import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class JdihNewsMenu extends StatelessWidget {
  final String label;
  final String title;
  final String date;

  const JdihNewsMenu({
    super.key,
    required this.label,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgGray,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowGray,
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: AppTheme.accentGreen,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF101217),
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.black.withOpacity(0.25),
              ),
              const SizedBox(width: 10),
              Text(
                date,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.23),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
