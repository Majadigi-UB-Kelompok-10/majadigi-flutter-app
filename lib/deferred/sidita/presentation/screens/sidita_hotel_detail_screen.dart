import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers/sd_providers.dart';
import '../widgets/sidita_map_view.dart';

class SiditaHotelDetailScreen extends HookConsumerWidget {
  final int id;

  const SiditaHotelDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sdHotelDetailProvider(id: id));

    return detailAsync.when(
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            body: Center(child: Text('Hotel tidak ditemukan')),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: detail.gambarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: detail.gambarUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(color: Colors.grey[300]),
                      )
                    : Container(color: Colors.grey[300]),
              ),

              // Custom App Bar Area
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.network(
                        'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165251/Sidita_Logo_ze4yom.png',
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Content Card
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Star Rating
                        if (detail.bintang != null)
                          Row(
                            children: [
                              ...List.generate(
                                detail.bintang!,
                                (_) => const Icon(Icons.star, color: Colors.amber, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${detail.bintang} Bintang',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        // Title
                        Text(
                          detail.nama ?? '',
                          style: const TextStyle(
                            color: Color(0xFF0F3B8C),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                detail.alamat ?? '',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                        // Price
                        if (detail.hargaMulai != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.payments_outlined, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Mulai dari Rp ${_formatPrice(detail.hargaMulai!)}',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Description
                        if (detail.deskripsi != null)
                          Text(
                            detail.deskripsi!,
                            style: const TextStyle(
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        if (detail.highlightText != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                left: BorderSide(color: Colors.blue[400]!, width: 4),
                              ),
                            ),
                            child: Text(
                              detail.highlightText!,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        // Lokasi Hotel Section
                        if (detail.lat != null && detail.lng != null) ...[
                          const Text(
                            'Lokasi Hotel',
                            style: TextStyle(
                              color: Color(0xFF0F3B8C),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SiditaMapView(
                            centerLat: detail.lat!,
                            centerLng: detail.lng!,
                            zoom: 15,
                            points: [
                              SiditaMapPoint(
                                lat: detail.lat!,
                                lng: detail.lng!,
                                nama: detail.nama,
                                thumbnailUrl: detail.gambarUrl,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => _openMaps(detail.lat!, detail.lng!),
                              icon: const Icon(Icons.directions, color: Colors.white),
                              label: const Text(
                                'Petunjuk Arah Ke Maps',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F3B8C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Gagal memuat: $e')),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  void _openMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
