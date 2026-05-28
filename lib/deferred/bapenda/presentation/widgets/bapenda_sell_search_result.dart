import 'package:flutter/material.dart';

import '../../domain/entities/njkb/bpd_njkb_entity.dart';

class BapendaSellSearchResult extends StatelessWidget {
  final BpdNjkbKalkulasiEntity result;
  final VoidCallback onClose;

  const BapendaSellSearchResult({
    super.key,
    required this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VehicleHeaderCard(njkb: result.njkb),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  size: 14, color: Color(0xFFF7B500)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ESTIMASI PAJAK TAHUNAN (PKB)',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F4DAF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...result.estimasi.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PlateEstimateCard(estimate: e),
              )),
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(
                width: 4,
                height: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFF138B4C)),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'BEA BALIK NAMA (BBN)',
                style: TextStyle(
                  fontSize: 21,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F4DAF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _BbnCard(beaBalikNama: result.beaBalikNama),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFECF2FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDCE6F4)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(Icons.info_outline,
                      size: 14, color: Color(0xFF1F5DBD)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nilai yang ditampilkan bersifat estimasi berdasarkan data referensi Bapenda Jawa Timur. Untuk informasi resmi, silakan kunjungi SAMSAT terdekat.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: Color(0xFF577093),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2F49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleHeaderCard extends StatelessWidget {
  final int njkb;

  const _VehicleHeaderCard({required this.njkb});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2B43),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car_filled,
                    color: Color(0xFF0F4DAF), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NILAI JUAL (NJKB)',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Color(0xFF8FA0BB),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _idr(njkb),
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _idr(int value) {
    final raw = value.toString();
    final formatted = raw.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }
}

class _PlateEstimateCard extends StatelessWidget {
  final BpdNjkbEstimasiEntity estimate;

  const _PlateEstimateCard({required this.estimate});

  @override
  Widget build(BuildContext context) {
    // Map jenisPlat to display colors
    final isKuning = estimate.jenisPlat.toLowerCase().contains('kuning');
    final badgeColor = isKuning
        ? const Color(0xFFF7B500)
        : estimate.jenisPlat.toLowerCase().contains('hitam')
            ? const Color(0xFF2B3545)
            : const Color(0xFFCC2929);
    final textColor = isKuning ? Colors.black87 : Colors.white;
    final iconColor = isKuning ? Colors.black54 : Colors.white70;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E6EF)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  estimate.jenisPlat.toUpperCase(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(Icons.car_crash_outlined, size: 12, color: iconColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _CostLine(label: 'PKB Potensial', value: estimate.pkb),
                const SizedBox(height: 8),
                _CostLine(label: 'Opsen PKB', value: estimate.opsen),
                const SizedBox(height: 10),
                Text(
                  estimate.label,
                  style: const TextStyle(
                    color: Color(0xFF577093),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BbnCard extends StatelessWidget {
  final BpdNjkbBeaBalikNamaEntity beaBalikNama;

  const _BbnCard({required this.beaBalikNama});

  @override
  Widget build(BuildContext context) {
    final rows = <_CostData>[
      _CostData('BBN I (Baru)', beaBalikNama.bbn1),
      _CostData('Opsen BBN I', beaBalikNama.opsenBbn1),
      _CostData('BBN II (Bekas)', beaBalikNama.bbn2),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E6EF)),
      ),
      child: Column(
        children: rows
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF42536D),
                        ),
                      ),
                    ),
                    Text(
                      _idr(e.value),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0E5ED9),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CostLine extends StatelessWidget {
  final String label;
  final int value;

  const _CostLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF556882),
            ),
          ),
        ),
        Text(
          _idr(value),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2B3545),
          ),
        ),
      ],
    );
  }
}

class _CostData {
  final String label;
  final int value;
  const _CostData(this.label, this.value);
}

String _idr(int value) {
  final raw = value.toString();
  final formatted = raw.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return formatted;
}
