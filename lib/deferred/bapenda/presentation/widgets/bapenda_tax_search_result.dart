import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../domain/entities/pajak/bpd_pajak_entity.dart';

class BapendaTaxSearchResult extends StatelessWidget {
  final BpdPajakEntity result;
  final VoidCallback onClose;

  const BapendaTaxSearchResult({
    super.key,
    required this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final identitas = result.identitas;
    final biaya = result.rincianBiaya;
    final estimasi5 = result.estimasi5Tahunan;

    // Build vehicle info grid data from the entity
    final vehicleInfo = <_InfoEntry>[
      _InfoEntry('MERK', identitas.merk),
      _InfoEntry('TIPE', identitas.tipe),
      _InfoEntry('MODEL', identitas.model),
      _InfoEntry('WARNA', identitas.warna),
      _InfoEntry('TAHUN BUAT', identitas.tahunBuat.toString()),
      _InfoEntry('MASA PAJAK', identitas.masaPajak),
    ];

    // Build annual cost rows
    final annualCosts = <_CostEntry>[
      _CostEntry('PKB Pokok', biaya.pkbPokok),
      _CostEntry('Opsen PKB', biaya.opsenPkb),
      _CostEntry('SWDKLLJ', biaya.swdkllj),
      _CostEntry('Parkir Berlangganan', biaya.parkirBerlangganan),
    ];

    // Build five-year cost rows
    final fiveYearCosts = <_CostEntry>[
      _CostEntry('Cetak STNK', estimasi5.cetakStnk),
      _CostEntry('Cetak TNKB', estimasi5.cetakTnkb),
    ];

    return Column(
      children: [
        const SizedBox(height: 28),
        const Divider(height: 1, color: Color(0xFFE7E7E7)),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.assignment_turned_in,
                    size: 18,
                    color: Color(0xFF0B9444),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Hasil Pencarian',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.jdihBlue,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: identitas.statusAktif
                          ? const Color(0xFFE1F5E9)
                          : const Color(0xFFFDE7E7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      identitas.statusAktif ? 'AKTIF' : 'TIDAK AKTIF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: identitas.statusAktif
                            ? const Color(0xFF17944A)
                            : const Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE7E7E7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppTheme.jdihBlue,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_car_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'IDENTITAS\nKENDARAAN',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              identitas.platNomor,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.15,
                                color: AppTheme.jdihBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate width for 2 columns, subtracting the 14px gap between them
                          final double itemWidth = (constraints.maxWidth - 14) / 2;

                          return Wrap(
                            spacing: 14, // Replaces crossAxisSpacing
                            runSpacing: 30, // Replaces mainAxisSpacing
                            children: vehicleInfo.map((entry) {
                              return SizedBox(
                                width: itemWidth,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // Adapts to child height dynamically
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.label,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.7,
                                        color: Color(0xFF9AA3B5),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 20,
                                        height: 1.2,
                                        fontWeight: entry.label == 'MASA PAJAK'
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: entry.label == 'MASA PAJAK'
                                            ? AppTheme.jdihBlue
                                            : const Color(0xFF252B36),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _CostCard(
                icon: Icons.fact_check_outlined,
                iconColor: AppTheme.jdihBlue,
                title: 'BIAYA PENUH TAHUNAN',
                rows: annualCosts,
                footerLabel: 'TOTAL PAJAK',
                footerValue: _idr(biaya.totalPajak),
              ),
              const SizedBox(height: 18),
              _CostCard(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFFFF8C1A),
                title: 'ESTIMASI BIAYA 5 TAHUNAN',
                rows: fiveYearCosts,
                infoText:
                    'Biaya ini berlaku saat perpanjangan 5 tahunan dan belum termasuk biaya cek fisik kendaraan.',
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE3E7EF),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Text(
                  'Nominal uang sah mengacu pada data SAMSAT. Angka yang tertera di situs ini bersifat informatif sementara. Selalu periksa kembali berkas fisik kendaraan Anda.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Color(0xFF6A7488),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2F49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onClose,
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

/// Helper class for the vehicle info grid
class _InfoEntry {
  final String label;
  final String value;
  const _InfoEntry(this.label, this.value);
}

/// Helper class for cost rows
class _CostEntry {
  final String label;
  final int value;
  const _CostEntry(this.label, this.value);
}

class _CostCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<_CostEntry> rows;
  final String? footerLabel;
  final String? footerValue;
  final String? infoText;

  const _CostCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.rows,
    this.footerLabel,
    this.footerValue,
    this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3D58),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4D5768),
                      ),
                    ),
                  ),
                  Text(
                    _idr(row.value),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272D38),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (footerLabel != null && footerValue != null) ...[
            const SizedBox(height: 2),
            const Divider(color: Color(0xFFE7E7E7), height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  footerLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9AA3B5),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      footerValue!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.jdihBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (infoText != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD5E4FF)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.jdihBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      infoText!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppTheme.jdihBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
