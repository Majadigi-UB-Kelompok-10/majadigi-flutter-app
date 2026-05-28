import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../core/providers/kh_providers.dart';

class KlinikHoaksReportScreen extends HookConsumerWidget {
  const KlinikHoaksReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final noHpController = useTextEditingController();
    final isiLaporanController = useTextEditingController();
    final linkBuktiController = useTextEditingController();
    final isSubmitting = useState<bool>(false);

    Future<void> submitReport() async {
      final nama = namaController.text.trim();
      final email = emailController.text.trim();
      final noHp = noHpController.text.trim();
      final isiLaporan = isiLaporanController.text.trim();

      if (nama.isEmpty || email.isEmpty || noHp.isEmpty || isiLaporan.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap lengkapi semua field wajib.')),
        );
        return;
      }

      isSubmitting.value = true;
      try {
        final result = await ref.read(
          khSubmitReportProvider(
            nama: nama,
            email: email,
            noHp: noHp,
            isiLaporan: isiLaporan,
            linkBukti: linkBuktiController.text.trim(),
          ).future,
        );

        if (!context.mounted) return;

        if (result != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Laporan Terkirim!'),
              content: Text(
                'Nomor tiket Anda: ${result.ticketNumber}\n'
                'Simpan nomor ini untuk melacak status laporan.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengirim laporan. Silakan coba lagi.')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        isSubmitting.value = false;
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
              'Permohonan Klarifikasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B8D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kirimkan detail informasi yang kamu dapat, akan kami bantu\ncari klarifikasinya dalam 1x24 jam.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(controller: namaController, hint: 'Nama Anda ...'),
            const SizedBox(height: 16),
            _buildTextField(controller: emailController, hint: 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(controller: noHpController, hint: 'No Hp', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(controller: isiLaporanController, hint: 'Isi Laporan ...', maxLines: 5),
            const SizedBox(height: 16),
            _buildTextField(controller: linkBuktiController, hint: 'Link Bukti/Alamat Website'),
            const SizedBox(height: 16),
            _buildFilePickerField(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting.value ? null : submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0044B2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: isSubmitting.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
      ),
    );
  }

  Widget _buildFilePickerField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // File picker functionality — requires adding image_picker or file_picker dependency
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose File',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
                Icon(Icons.upload_file, color: Colors.blue.shade700, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
