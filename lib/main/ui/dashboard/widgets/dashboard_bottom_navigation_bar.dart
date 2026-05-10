import 'package:flutter/material.dart';

/// Custom Navigation Bar Implementation
class DashboardBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 0, bottom: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => onTap(0),
              behavior: HitTestBehavior.opaque,
              child: _CustomNavigationItems(icon: Icons.home, label: 'Beranda', active: currentIndex == 0),
            ),
            GestureDetector(
              onTap: () => onTap(1),
              behavior: HitTestBehavior.opaque,
              child: _CustomNavigationItems(icon: Icons.grid_view, label: 'Layanan', active: currentIndex == 1),
            ),
            GestureDetector(
              onTap: () => onTap(2),
              behavior: HitTestBehavior.opaque,
              child: _CustomNavigationItems(icon: Icons.person_outline, label: 'Profil', active: currentIndex == 2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation Items used in Custom Navigation Bar
class _CustomNavigationItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _CustomNavigationItems({
    required this.icon,
    required this.label,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0D47A1) : Colors.grey[500];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Indicator above icon (flush to nav top)
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 6,
          width: active ? 48 : 0,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0D47A1) : Colors.transparent,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
        ),
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}