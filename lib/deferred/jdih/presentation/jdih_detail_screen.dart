import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../data/jdih_document.dart';

class JdihDetailScreen extends StatelessWidget {
  final JdihDocument document;

  const JdihDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background body abu-abu muda agar card terlihat kontras
      backgroundColor: const Color(0xFFF1F5F9), 
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Dokumen',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
      ),
      body: Column(
        children: [
          // Bagian Header Biru yang melengkung di bawah AppBar
          Container(
            height: 40,
            width: double.infinity,
            color: AppTheme.jdihBlue,
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40), // Menaikkan card agar masuk ke area biru
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Card Putih Utama
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge Tipe
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F7FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              document.category.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.jdihBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Judul Besar
                          Text(
                            document.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Informasi Detail
                          Text(
                            'INFORMASI DETAIL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              children: [
                                _InfoRow(label: 'Jenis', value: document.category),
                                const _RowDivider(),
                                _InfoRow(label: 'Nomor', value: document.nomor),
                                const _RowDivider(),
                                _InfoRow(label: 'Tahun', value: document.tahun),
                                const _RowDivider(),
                                _InfoRow(label: 'Tgl. Penetapan', value: document.tglPenetapan),
                                const _RowDivider(),
                                _InfoRow(
                                  label: 'Status',
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8FDF5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        document.status,
                                        style: const TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tombol Unduh PDF (Outline Style)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.picture_as_pdf, size: 22),
                              label: Text('Unduh PDF (${document.pdfSize})',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D47A1),
                                side: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Metadata Section
                          Text(
                            'METADATA TAMBAHAN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9EEF5),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'URUSAN PEMERINTAHAN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Kepegawaian dan Kesekretariatan Daerah',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'SUBJEK',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: const [
                                    _Pill(text: 'Bendera Negara'),
                                    _Pill(text: 'Hari Berkabung'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Bar (Sesuai Gambar)
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                _BottomIconButton(icon: Icons.bookmark_border),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined, size: 20),
                    label: const Text('Bagikan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _BottomIconButton(icon: Icons.print_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  final IconData icon;
  const _BottomIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: const Color(0xFF475569)),
      ),
    );
  }
}

// ... _InfoRow dan _RowDivider kamu sudah cukup oke, tinggal sesuaikan font weight value-nya.

// ─── Baris info tabel ──────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;

  const _InfoRow({required this.label, this.value, this.child}) : assert(value != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: child ?? Text(
              value!,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF101217),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFE8EDF2),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD7E8FF)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.jdihBlue)),
    );
  }
}
