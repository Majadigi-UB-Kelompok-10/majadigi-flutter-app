import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/bpd_providers.dart';
import 'bapenda_captcha.dart';

class BapendaSellForm extends HookConsumerWidget {
  final Future<void> Function({
    required String jenis,
    required String merk,
    required String model,
    required String tipe,
    required int tahun,
  }) onSearch;

  const BapendaSellForm({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Selected values
    final selectedJenis = useState<String?>(null);
    final selectedMerk = useState<String?>(null);
    final selectedModel = useState<String?>(null);
    final selectedTipe = useState<String?>(null);
    final selectedTahun = useState<int?>(null);

    // Lists
    final jenisList = useState<List<String>>([]);
    final merkList = useState<List<String>>([]);
    final modelList = useState<List<String>>([]);
    final tipeList = useState<List<String>>([]);
    final tahunList = useState<List<int>>([]);

    // Loading states
    final isLoadingJenis = useState(false);
    final isLoadingMerk = useState(false);
    final isLoadingModel = useState(false);
    final isLoadingTipe = useState(false);
    final isLoadingTahun = useState(false);

    // Captcha
    final isCaptchaChecked = useState(false);

    // Fetch Jenis on mount
    useEffect(() {
      isLoadingJenis.value = true;
      ref.read(bpdGetJenisProvider).execute().then((data) {
        jenisList.value = data;
        isLoadingJenis.value = false;
      }).catchError((_) {
        isLoadingJenis.value = false;
      });
      return null;
    }, []);

    // Fetch Merk when Jenis changes
    useEffect(() {
      if (selectedJenis.value != null) {
        isLoadingMerk.value = true;
        merkList.value = [];
        selectedMerk.value = null;
        modelList.value = [];
        selectedModel.value = null;
        tipeList.value = [];
        selectedTipe.value = null;
        tahunList.value = [];
        selectedTahun.value = null;

        ref
            .read(bpdGetMerkProvider)
            .execute(jenis: selectedJenis.value!)
            .then((data) {
          merkList.value = data;
          isLoadingMerk.value = false;
        }).catchError((_) {
          isLoadingMerk.value = false;
        });
      }
      return null;
    }, [selectedJenis.value]);

    // Fetch Model when Merk changes
    useEffect(() {
      if (selectedMerk.value != null) {
        isLoadingModel.value = true;
        modelList.value = [];
        selectedModel.value = null;
        tipeList.value = [];
        selectedTipe.value = null;
        tahunList.value = [];
        selectedTahun.value = null;

        ref
            .read(bpdGetModelProvider)
            .execute(
              jenis: selectedJenis.value!,
              merk: selectedMerk.value!,
            )
            .then((data) {
          modelList.value = data;
          isLoadingModel.value = false;
        }).catchError((_) {
          isLoadingModel.value = false;
        });
      }
      return null;
    }, [selectedMerk.value]);

    // Fetch Tipe when Model changes
    useEffect(() {
      if (selectedModel.value != null) {
        isLoadingTipe.value = true;
        tipeList.value = [];
        selectedTipe.value = null;
        tahunList.value = [];
        selectedTahun.value = null;

        ref
            .read(bpdGetTipeProvider)
            .execute(
              jenis: selectedJenis.value!,
              merk: selectedMerk.value!,
              model: selectedModel.value!,
            )
            .then((data) {
          tipeList.value = data;
          isLoadingTipe.value = false;
        }).catchError((_) {
          isLoadingTipe.value = false;
        });
      }
      return null;
    }, [selectedModel.value]);

    // Fetch Tahun when Tipe changes
    useEffect(() {
      if (selectedTipe.value != null) {
        isLoadingTahun.value = true;
        tahunList.value = [];
        selectedTahun.value = null;

        ref
            .read(bpdGetTahunProvider)
            .execute(
              jenis: selectedJenis.value!,
              merk: selectedMerk.value!,
              model: selectedModel.value!,
              tipe: selectedTipe.value!,
            )
            .then((data) {
          tahunList.value = data;
          isLoadingTahun.value = false;
        }).catchError((_) {
          isLoadingTahun.value = false;
        });
      }
      return null;
    }, [selectedTipe.value]);

    Future<void> handleSearch() async {
      if (selectedJenis.value == null ||
          selectedMerk.value == null ||
          selectedModel.value == null ||
          selectedTipe.value == null ||
          selectedTahun.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi semua field terlebih dahulu')),
        );
        return;
      }

      if (!isCaptchaChecked.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifikasi robot terlebih dahulu')),
        );
        return;
      }

      await onSearch(
        jenis: selectedJenis.value!,
        merk: selectedMerk.value!,
        model: selectedModel.value!,
        tipe: selectedTipe.value!,
        tahun: selectedTahun.value!,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E7F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('JENIS KENDARAAN'),
          const SizedBox(height: 8),
          _buildDropdown<String>(
            value: selectedJenis.value,
            hint: 'Pilih Jenis',
            items: jenisList.value,
            isLoading: isLoadingJenis.value,
            onChanged: (v) => selectedJenis.value = v,
            itemLabel: (e) => e,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DropdownFieldBlock<String>(
                  label: 'MERK',
                  value: selectedMerk.value,
                  hint: 'Pilih Merk',
                  items: merkList.value,
                  isLoading: isLoadingMerk.value,
                  enabled: selectedJenis.value != null,
                  onChanged: (v) => selectedMerk.value = v,
                  itemLabel: (e) => e,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DropdownFieldBlock<String>(
                  label: 'MODEL',
                  value: selectedModel.value,
                  hint: 'Pilih Model',
                  items: modelList.value,
                  isLoading: isLoadingModel.value,
                  enabled: selectedMerk.value != null,
                  onChanged: (v) => selectedModel.value = v,
                  itemLabel: (e) => e,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DropdownFieldBlock<String>(
                  label: 'TYPE',
                  value: selectedTipe.value,
                  hint: 'Pilih Type',
                  items: tipeList.value,
                  isLoading: isLoadingTipe.value,
                  enabled: selectedModel.value != null,
                  onChanged: (v) => selectedTipe.value = v,
                  itemLabel: (e) => e,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DropdownFieldBlock<int>(
                  label: 'TAHUN',
                  value: selectedTahun.value,
                  hint: 'Pilih Tahun',
                  items: tahunList.value,
                  isLoading: isLoadingTahun.value,
                  enabled: selectedTipe.value != null,
                  onChanged: (v) => selectedTahun.value = v,
                  itemLabel: (e) => e.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BapendaCaptcha(
            onChanged: (v) => isCaptchaChecked.value = v,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: handleSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E5ED9),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.search, size: 16, color: Colors.white),
              label: const Text(
                'Cari Nilai Jual',
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

  Widget _buildLabel(String text) {
    return Row(
      children: [
        const Icon(Icons.brightness_1, size: 5, color: Color(0xFF10A84F)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1346A3),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemLabel,
    bool isLoading = false,
    bool enabled = true,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDCE3EE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF2A3241),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF9FA9BA)),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(itemLabel(e)),
                ),
              )
              .toList(),
          onChanged: enabled && !isLoading ? onChanged : null,
        ),
      ),
    );
  }
}

class _DropdownFieldBlock<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String hint;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final bool isLoading;
  final bool enabled;

  const _DropdownFieldBlock({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.brightness_1, size: 5, color: Color(0xFF0E5ED9)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1346A3),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDCE3EE)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(
                  color: Color(0xFF2A3241),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF9FA9BA)),
              items: items
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(itemLabel(e)),
                    ),
                  )
                  .toList(),
              onChanged: enabled && !isLoading ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
