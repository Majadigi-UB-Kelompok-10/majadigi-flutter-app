import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../core/providers/jd_providers.dart';
import '../domain/entities/dokumen_detail/jd_dokumen_detail_entity.dart';

class JdihDetailScreen extends HookConsumerWidget {
  final int documentId;

  const JdihDetailScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(jdDokumenDetailProvider(documentId));

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppTheme.jdihBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Dokumen',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
        ),
      ),
      body: detailAsync.when(
        data: (document) {
          if (document == null) {
            return const Center(
              child: Text('Dokumen tidak ditemukan',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }
          return _DetailContent(document: document);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: Colors.red, fontSize: 14)),
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final JdDokumenDetailEntity document;

  const _DetailContent({required this.document});

  String _formatPdfSize(int? sizeKb) {
    if (sizeKb == null) return '';
    if (sizeKb >= 1024) {
      return '${(sizeKb / 1024).toStringAsFixed(1)} MB';
    }
    return '$sizeKb KB';
  }

  String _formatViews(int? views) {
    if (views == null) return '0';
    if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}k';
    }
    return views.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue header continuation
        Container(
          height: 40,
          width: double.infinity,
          color: AppTheme.jdihBlue,
        ),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Main white card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F7FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (document.jenis ?? '').toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.jdihBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          document.judul ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        // Ringkasan (summary)
                        if (document.ringkasan != null &&
                            document.ringkasan!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            document.ringkasan!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              height: 1.5,
                            ),
                          ),
                        ],

                        // View count
                        if (document.jumlahView != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.visibility_outlined,
                                  size: 16, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 6),
                              Text(
                                '${_formatViews(document.jumlahView)} dilihat',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Detail info section
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
                              _InfoRow(
                                  label: 'Jenis',
                                  value: document.jenis ?? '-'),
                              const _RowDivider(),
                              _InfoRow(
                                  label: 'Nomor',
                                  value: document.nomor ?? '-'),
                              const _RowDivider(),
                              _InfoRow(
                                  label: 'Tahun',
                                  value: document.tahun?.toString() ?? '-'),
                              const _RowDivider(),
                              _InfoRow(
                                  label: 'Tgl. Penetapan',
                                  value: document.tanggalPenetapan ?? '-'),
                              const _RowDivider(),
                              _InfoRow(
                                label: 'Status',
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8FDF5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      document.status ?? '-',
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

                        // Download PDF button
                        if (document.pdfUrl != null &&
                            document.pdfUrl!.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse(document.pdfUrl!);
                                await launchUrl(uri);
                              },
                              icon:
                                  const Icon(Icons.picture_as_pdf, size: 22),
                              label: Text(
                                  'Unduh PDF (${_formatPdfSize(document.pdfSizeKb)})',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D47A1),
                                side: const BorderSide(
                                    color: Color(0xFF0D47A1), width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),

                        const SizedBox(height: 30),

                        // Metadata section
                        if (document.urusanPemerintahan != null ||
                            (document.subjek != null &&
                                document.subjek!.isNotEmpty)) ...[
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
                                if (document.urusanPemerintahan != null) ...[
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
                                    document.urusanPemerintahan!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (document.subjek != null &&
                                      document.subjek!.isNotEmpty)
                                    const SizedBox(height: 16),
                                ],
                                if (document.subjek != null &&
                                    document.subjek!.isNotEmpty) ...[
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
                                    children: document.subjek!
                                        .map((s) =>
                                            _Pill(text: s.nama ?? ''))
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Bottom Bar
        Container(
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              // _BottomIconButton(icon: Icons.bookmark_border),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (document.pdfUrl != null && document.pdfUrl!.isNotEmpty) {
                      await SharePlus.instance.share(
                          ShareParams(
                              title: document.judul ?? "Sharing",
                              text: "Lihat dokumen ${document.jenis != null ? document.jenis!.toUpperCase() : "JDIH" } ini!\n${document.pdfUrl!}",
                              subject: 'Great Read!'
                          )
                      );
                    }
                  },
                  icon: const Icon(Icons.share_outlined, size: 20),
                  label: const Text('Bagikan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // _BottomIconButton(icon: Icons.print_outlined),
            ],
          ),
        ),
      ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;

  const _InfoRow({required this.label, this.value, this.child})
      : assert(value != null || child != null);

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
            child: child ??
                Text(
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
      child: Text(text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.jdihBlue)),
    );
  }
}
