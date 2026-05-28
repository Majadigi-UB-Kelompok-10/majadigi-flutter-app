import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HoaksPromoCarousel extends StatefulWidget {
  const HoaksPromoCarousel({super.key});

  @override
  State<HoaksPromoCarousel> createState() => _HoaksPromoCarouselState();
}

class _HoaksPromoCarouselState extends State<HoaksPromoCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToReport() {
    context.push('/klinik-hoaks/report');
  }

  void _navigateToTrack() {
    context.push('/klinik-hoaks/track');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF0044B2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPromoItem(
                title: 'Laporan Hoaks',
                subtitle: 'Kirim info yang Kamu temukan, Kami bantu klarifikasi dalam 1x24 jam.',
                onPressed: _navigateToReport,
              ),
              _buildPromoItem(
                title: 'Cek Laporan Hoaks',
                subtitle: 'Lacak status laporan hoaks yang pernah kamu kirimkan ke Klinik Hoaks.',
                onPressed: _navigateToTrack,
              ),
            ],
          ),
          Positioned(
            bottom: 12,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoItem({
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(100, 32),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Selengkapnya',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: _currentPage == index ? 12 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.orange.shade800 : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
