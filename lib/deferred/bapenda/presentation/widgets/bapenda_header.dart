import 'package:flutter/material.dart';

class BapendaHeader extends StatefulWidget {
  final int activeTab;
  final ValueChanged<int> onTabChanged;

  const BapendaHeader({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<BapendaHeader> createState() => _BapendaHeaderState();
}

class _BapendaHeaderState extends State<BapendaHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 0),
      decoration: const BoxDecoration(
        color: Color(0xFF0652C5), // Warna biru Bapenda
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Logo Bapenda Jatim Putih
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 260),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://res.cloudinary.com/duxmv7lnl/image/upload/v1777988602/xpfrcz3iccsqherisfwn.png',
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'bapenda\njatim',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Tab System
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTabItem('Info Pajak', 0),
              _buildTabItem('Nilai Jual', 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = widget.activeTab == index;
    return GestureDetector(
      onTap: () => widget.onTabChanged(index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isActive)
            Container(
              height: 3,
              width: 60,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
