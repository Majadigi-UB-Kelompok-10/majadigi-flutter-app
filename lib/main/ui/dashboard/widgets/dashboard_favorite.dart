import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/service/service_entity.dart';

/// Favorite Widget for Dashboard
class DashboardFavorite extends StatelessWidget {
  final List<ServiceEntity> serviceList;
  final Widget? textButton;
  const DashboardFavorite({super.key, required this.serviceList, this.textButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _FavoriteHeader(title: 'Layanan Favorit', textButton: textButton),

        // Cards
        _FavoriteCards(services: serviceList),
      ],
    );
  }
}

/// Header for Favorite Widget
class _FavoriteHeader extends StatelessWidget {
  final String title;
  final Widget? textButton;
  const _FavoriteHeader({super.key, required this.title, this.textButton});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ?textButton,
        ],
      ),
    );
  }
}

/// Scrollable Horizontal Cards for Favorite Widget
class _FavoriteCards extends StatelessWidget {
  final List<ServiceEntity> services;
  const _FavoriteCards({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.99,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Sesuaikan padding
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Biar box-nya gak maksa narik ke bawah
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apps, color: Colors.blue),
              const SizedBox(height: 4), // Jarak kecil antara icon dan teks
              Text(
                services[index].title!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF0652C5), // Warna teks bisa disesuaikan biar senada
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Biar kalau kepanjangan gak ngerusak box
              ),
            ],
          ),
        );
      },
    );
  }
}