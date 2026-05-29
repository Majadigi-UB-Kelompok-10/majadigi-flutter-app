import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/providers/snk_providers.dart';
import '../../domain/entities/pendaftaran/snk_pendaftaran_entity.dart';
import '../widgets/sinaker_widgets.dart';

class SinakerStatusScreen extends HookConsumerWidget {
  const SinakerStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nikController = useTextEditingController();
    final noHpController = useTextEditingController();
    final isSearching = useState(false);
    final searchResults = useState<List<SnkStatusPendaftaranEntity>?>(null);
    final searchError = useState<String?>(null);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Sinaker',
          style: TextStyle(
            color: Color(0xFF003B8D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cek Status Pendaftaran',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B8D),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan masukkan NIK dan Nomor HP Anda untuk\nmengecek status pendaftaran pelatihan.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildSearchForm(
              context: context,
              ref: ref,
              nikController: nikController,
              noHpController: noHpController,
              isSearching: isSearching,
              searchResults: searchResults,
              searchError: searchError,
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('BUKTI PENDAFTARAN'),
            const SizedBox(height: 16),
            _buildResults(
              isSearching: isSearching.value,
              results: searchResults.value,
              error: searchError.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController nikController,
    required TextEditingController noHpController,
    required ValueNotifier<bool> isSearching,
    required ValueNotifier<List<SnkStatusPendaftaranEntity>?> searchResults,
    required ValueNotifier<String?> searchError,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SinakerTextField(
            label: 'NIK',
            hintText: 'Masukkan 16 digit NIK',
            keyboardType: TextInputType.number,
            controller: nikController,
          ),
          const SizedBox(height: 16),
          SinakerTextField(
            label: 'NO HP',
            hintText: 'Masukkan Nomor Handphone',
            keyboardType: TextInputType.phone,
            controller: noHpController,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSearching.value
                  ? null
                  : () async {
                      if (nikController.text.isEmpty || noHpController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mohon isi NIK dan No HP')),
                        );
                        return;
                      }

                      isSearching.value = true;
                      searchError.value = null;

                      try {
                        final results = await ref.read(
                          snkCekStatusProvider(
                            nik: nikController.text,
                            noWa: noHpController.text,
                          ).future,
                        );
                        searchResults.value = results;
                      } catch (e) {
                        searchError.value = e.toString();
                        searchResults.value = null;
                      } finally {
                        isSearching.value = false;
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B8D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSearching.value
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Cari',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          color: const Color(0xFF003B8D),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildResults({
    required bool isSearching,
    required List<SnkStatusPendaftaranEntity>? results,
    required String? error,
  }) {
    if (isSearching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 32),
            const SizedBox(height: 16),
            Text(
              'Gagal mengambil data',
              style: TextStyle(fontSize: 12, color: Colors.red.shade600),
            ),
          ],
        ),
      );
    }

    if (results == null) {
      return _buildEmptyState();
    }

    if (results.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.grey.shade400, size: 32),
            const SizedBox(height: 16),
            Text(
              'Tidak ditemukan riwayat pendaftaran',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: results.map((item) => _buildStatusCard(item)).toList(),
    );
  }

  Widget _buildStatusCard(SnkStatusPendaftaranEntity item) {
    Color statusColor;
    switch (item.status.toLowerCase()) {
      case 'diterima':
        statusColor = Colors.green;
        break;
      case 'ditolak':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.blkNama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.kejuruanNama,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            'Tanggal Daftar: ${item.tanggalDaftar}',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Masukkan NIK dan No HP untuk melihat status',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
