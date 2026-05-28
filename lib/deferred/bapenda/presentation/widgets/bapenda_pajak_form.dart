import 'package:flutter/material.dart';

import 'bapenda_captcha.dart';
import 'bapenda_label.dart';
import 'bapenda_text_field.dart';

class BapendaPajakForm extends StatefulWidget {
  final Future<void> Function(String platNomor, String nomorRangka) onSearch;

  const BapendaPajakForm({
    super.key,
    required this.onSearch,
  });

  @override
  State<BapendaPajakForm> createState() => _BapendaPajakFormState();
}

class _BapendaPajakFormState extends State<BapendaPajakForm> {
  late TextEditingController _plateNumberController;
  late TextEditingController _frameNumberController;
  bool _isCaptchaChecked = false;

  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController();
    _frameNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _frameNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final plateText = _plateNumberController.text.replaceAll(' ', '');
    final frameText = _frameNumberController.text.trim();

    if (plateText.isEmpty || frameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field')),
      );
      return;
    }
    if (frameText.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor rangka minimal 5 digit')),
      );
      return;
    }
    if (!_isCaptchaChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifikasi reCAPTCHA terlebih dahulu')),
      );
      return;
    }

    // Extract last 5 digits if longer
    final nomorRangka = frameText.length > 5
        ? frameText.substring(frameText.length - 5)
        : frameText;

    await widget.onSearch(plateText, nomorRangka);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.blue.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BapendaLabel('PLAT NOMOR KENDARAAN'),
          BapendaTextField(
            hint: 'Contoh: L 1234 ABC',
            controller: _plateNumberController,
          ),
          const SizedBox(height: 20),
          BapendaLabel('5 DIGIT TERAKHIR NOMOR RANGKA'),
          BapendaTextField(
            hint: '.....',
            controller: _frameNumberController,
            isMasked: true,
          ),
          const SizedBox(height: 30),
          BapendaCaptcha(
            onChanged: (value) => setState(() => _isCaptchaChecked = value),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0061FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.blue.withOpacity(0.4),
              ),
              onPressed: _handleSearch,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Cari Data Kendaraan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
