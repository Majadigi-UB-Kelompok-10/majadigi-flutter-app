import 'package:flutter/material.dart';
import '../../../../deferred/theme/app_theme.dart';

class TjRouteStopItem extends StatelessWidget {
  final String name;
  final bool isLast;

  const TjRouteStopItem({
    super.key,
    required this.name,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.jdihBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 42,
                    margin: const EdgeInsets.only(top: 10),
                    color: const Color(0xFFBFD0FF),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
