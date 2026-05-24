import 'package:flutter/material.dart';

import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import '../../domain/entities/bansos/bansos_entity.dart';

class BansosDetailScreen extends StatelessWidget {
  final RiwayatEntity benefit;

  const BansosDetailScreen({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.jdihBlue,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Detail Bansos',
                          style: TextStyle(
                            color: AppTheme.jdihBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  _ProgramCard(benefit: benefit),
                  const SizedBox(height: 16),
                  _DescriptionCard(benefit: benefit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final RiwayatEntity benefit;

  const _ProgramCard({required this.benefit});

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
          const Text(
            'Program',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            benefit.programNama,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),
          _DetailRow(
            label: 'Nominal',
            value: benefit.nominal,
            valueColor: _getStatusColor(),
            valueBackground: _getStatusBackground(),
            isBadge: true,
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Periode', value: benefit.periode),
          const SizedBox(height: 10),
          _DetailRow(label: 'Metode', value: 'Transfer Bank / Tunai'),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Status',
            value: benefit.status.toUpperCase(),
            valueColor: _getStatusColor(),
            valueBackground: _getStatusBackground(),
            isBadge: true,
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final RiwayatEntity benefit;

  const _DescriptionCard({required this.benefit});

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
          const Text(
            'Deskripsi',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            benefit.programNama,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bantuan ini diberikan sebagai bentuk dukungan pemerintah kepada masyarakat yang memenuhi syarat.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Color? valueBackground;
  final bool isBadge;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBackground,
    this.isBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: isBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: valueBackground ?? const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: valueColor ?? const Color(0xFF16A34A),
                      ),
                    ),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
