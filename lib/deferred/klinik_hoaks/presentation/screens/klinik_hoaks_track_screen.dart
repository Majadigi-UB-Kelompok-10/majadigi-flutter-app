import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../core/providers/kh_providers.dart';
import '../../domain/entities/report/kh_track_report_entity.dart';

class KlinikHoaksTrackScreen extends HookConsumerWidget {
  const KlinikHoaksTrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketController = useTextEditingController();
    final hasSearched = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final trackResult = useState<KhTrackReportEntity?>(null);
    final errorMessage = useState<String?>(null);

    Future<void> searchTicket() async {
      final query = ticketController.text.trim();
      if (query.isEmpty) return;

      hasSearched.value = true;
      isLoading.value = true;
      errorMessage.value = null;

      try {
        final result = await ref.read(
          khTrackReportProvider(ticketNumber: query).future,
        );
        trackResult.value = result;
      } catch (e) {
        errorMessage.value = 'Gagal melacak tiket. Silakan coba lagi.';
        trackResult.value = null;
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0044B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Klinik Hoaks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Layanan verifikasi informasi dan deteksi hoaks.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Pelacakan Tiket Permohonan Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B8D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan no tiket yang telah dikirim ke WhatsApp dan\nEmail anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: ticketController,
              decoration: InputDecoration(
                hintText: 'No Tiket',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : searchTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0044B2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Lacak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 48),
            if (!hasSearched.value)
              const SizedBox()
            else if (isLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.value != null)
              Center(
                child: Text(
                  errorMessage.value!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              )
            else if (trackResult.value == null)
              Center(
                child: Text(
                  'No Result found Yet!',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              )
            else
              _buildTrackResult(trackResult.value!),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackResult(KhTrackReportEntity result) {
    Color statusColor;
    switch (result.reportStatus?.toUpperCase()) {
      case 'PENDING':
        statusColor = Colors.orange.shade700;
        break;
      case 'VERIFIED':
      case 'DONE':
        statusColor = Colors.green.shade700;
        break;
      case 'REJECTED':
        statusColor = Colors.red.shade700;
        break;
      default:
        statusColor = Colors.grey.shade700;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1 Result Found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('No Tiket', result.ticketNumber ?? '-'),
          const SizedBox(height: 12),
          _buildInfoRow('Pelapor', result.reporterName ?? '-'),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  result.reportStatus ?? '-',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Dilaporkan', result.reportedAt ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
