import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/providers/sd_providers.dart';
import '../../domain/entities/event/sd_event_entity.dart';
import '../widgets/destination_card.dart';
import '../widgets/event_card.dart';

class SiditaMainScreen extends HookConsumerWidget {
  const SiditaMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationRecsAsync = ref.watch(sdDestinationRecommendationsProvider);
    final eventRecsAsync = ref.watch(sdEventRecommendationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F3B8C),
                    Color(0xFF2196F3),
                    Colors.white,
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      Image.network(
                        'https://res.cloudinary.com/dpnx82uzs/image/upload/v1778165251/Sidita_Logo_ze4yom.png',
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Jelajahi Jawa Timur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Temukan keajaiban alam & budaya di setiap sudut provinsi dengan pengalaman tak terlupakan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  // Quick Menus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickMenu(
                        context,
                        icon: Icons.location_on,
                        label: 'Destinasi',
                        color: Colors.blue,
                        onTap: () => context.push('/sidita/destinasi'),
                      ),
                      _buildQuickMenu(
                        context,
                        icon: Icons.hotel,
                        label: 'Hotel',
                        color: Colors.green,
                        onTap: () => context.push('/sidita/hotel'),
                      ),
                      _buildQuickMenu(
                        context,
                        icon: Icons.calendar_month,
                        label: 'Event',
                        color: Colors.orange,
                        onTap: () => context.push('/sidita/event'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rekomendasi Pariwisata
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Pariwisata',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.push('/sidita/destinasi'),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: destinationRecsAsync.when(
                data: (recs) {
                  if (recs.isEmpty) {
                    return const Center(child: Text('Belum ada rekomendasi'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: recs.length,
                    itemBuilder: (context, index) {
                      final destination = recs[index];
                      return DestinationCard(
                        destination: destination,
                        onTap: () {
                          if (destination.id != null) {
                            context.push('/sidita/destinasi/${destination.id}');
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Gagal memuat: $e')),
              ),
            ),
            const SizedBox(height: 24),

            // Kharisma Event Nusantara
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kharisma Event Nusantara',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: eventRecsAsync.when(
                      data: (eventRecs) {
                        if (eventRecs.isEmpty) {
                          return const Center(child: Text('Belum ada event'));
                        }
                        final rec = eventRecs.first;
                        final eventEntity = SdEventEntity(
                          id: rec.id,
                          nama: rec.nama,
                          alamat: rec.alamat,
                          gambarUrlThumbnail: rec.gambarUrlThumbnail,
                          bulan: rec.bulan,
                        );
                        return EventCard(
                          event: eventEntity,
                          onTap: () {
                            if (rec.id != null) {
                              context.push('/sidita/event/${rec.id}');
                            }
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Lihat Event Lainnya Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B8C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'INGIN LIHAT EVENT\nLAINNYA?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/sidita/event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenu(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
