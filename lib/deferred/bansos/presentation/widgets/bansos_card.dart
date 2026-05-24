import 'package:flutter/material.dart';

import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import '../../domain/entities/bansos/bansos_entity.dart';

class BansosBenefitCard extends StatelessWidget {
  final RiwayatEntity benefit;
  final VoidCallback? onTap;

  const BansosBenefitCard({super.key, required this.benefit, this.onTap});

  Color _getStatusColor() {
    if (benefit.status.toUpperCase() == 'DITERIMA') return const Color(0xFF16A34A);
    if (benefit.status.toUpperCase() == 'PROSES') return const Color(0xFFF59E0B);
    return const Color(0xFF64748B);
  }

  Color _getStatusBackground() {
    if (benefit.status.toUpperCase() == 'DITERIMA') return const Color(0xFFD1FAE5);
    if (benefit.status.toUpperCase() == 'PROSES') return const Color(0xFFFDE68A);
    return const Color(0xFFF1F5F9);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  benefit.programNama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusBackground(),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  benefit.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            benefit.periode,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            benefit.nominal,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: const Text(
              'Lihat Detail >',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
