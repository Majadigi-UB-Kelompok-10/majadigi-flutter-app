import 'package:flutter/material.dart';
import '../../domain/entities/summary/rssa_summary_entity.dart';
import '../../domain/entities/ruangan/rssa_ruangan_entity.dart';

class RoomAvailabilityCard extends StatelessWidget {
  final RssaSummaryEntity? summary;

  const RoomAvailabilityCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bed, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (summary == null || summary!.totalKapasitas == 0) ? 0 : (summary!.totalKapasitas - summary!.totalTersedia) / summary!.totalKapasitas,
                    backgroundColor: Colors.red.shade700,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade600,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${summary?.totalTersedia ?? 0} Kamar Masih Tersedia dari ${summary?.totalKapasitas ?? 0}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomListItem extends StatelessWidget {
  final RssaRuanganEntity room;

  const RoomListItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = room.tersedia > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color border
            Container(
              width: 6,
              decoration: BoxDecoration(
                // Use a default color based on class since we don't have the hardcoded colors anymore
                color: room.kelasSlug == 'vip' || room.kelasSlug == 'vvip' ? Colors.amber 
                     : room.kelasSlug == 'kelas-1' ? Colors.blue.shade200 
                     : room.kelasSlug == 'kelas-2' ? Colors.green
                     : Colors.teal,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Room details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            room.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildInfoChip(
                                'Kapasitas: ${room.kapasitas}',
                                Colors.grey.shade200,
                                Colors.black87,
                              ),
                              _buildInfoChip(
                                'Terisi: ${room.terisi}',
                                Colors.pink.shade50,
                                Colors.pink,
                              ),
                              _buildInfoChip(
                                'Tersedia: ${room.tersedia}',
                                Colors.green.shade50,
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Circular availability indicator
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isAvailable
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${room.tersedia}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                          Text(
                            'Tersedia',
                            style: TextStyle(
                              fontSize: 8,
                              color: isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
