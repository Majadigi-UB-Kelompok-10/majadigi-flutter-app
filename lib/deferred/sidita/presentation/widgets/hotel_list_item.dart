import 'package:flutter/material.dart';
import '../../domain/entities/hotel/sd_hotel_entity.dart';

class HotelListItem extends StatelessWidget {
  final SdHotelEntity hotel;
  final VoidCallback? onTap;

  const HotelListItem({
    super.key,
    required this.hotel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.nama ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3B8C),
                    ),
                  ),
                  if (hotel.bintang != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        hotel.bintang!,
                        (_) => const Icon(Icons.star, color: Colors.amber, size: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      hotel.areaNama?.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF0F3B8C)),
                      const SizedBox(width: 4),
                      const Text(
                        'Detail',
                        style: TextStyle(
                          color: Color(0xFF0F3B8C),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
