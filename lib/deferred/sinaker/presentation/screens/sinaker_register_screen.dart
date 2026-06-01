import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/snk_providers.dart';
import '../../domain/entities/kejuruan/snk_kejuruan_entity.dart';
import '../../domain/entities/wilayah/snk_wilayah_entity.dart';
import '../widgets/sinaker_widgets.dart';

class SinakerRegisterScreen extends HookConsumerWidget {
  final int blkId;
  final String blkName;

  const SinakerRegisterScreen({
    super.key,
    required this.blkId,
    required this.blkName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form controllers
    final nikController = useTextEditingController();
    final namaController = useTextEditingController();
    final tempatLahirController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final emailController = useTextEditingController();
    final rtController = useTextEditingController();
    final rwController = useTextEditingController();
    final alamatController = useTextEditingController();
    final noWaController = useTextEditingController();
    final noWaDaruratController = useTextEditingController();
    final asalSekolahController = useTextEditingController();
    final jurusanController = useTextEditingController();

    // State hooks
    final gender = useState('laki_laki');
    final penyandangDisabilitas = useState(false);
    final pendidikanTerakhir = useState('sma_smk');
    final pendidikanSekarang = useState('tidak_sekolah');
    final fotoFile = useState<File?>(null);
    final isSubmitting = useState(false);

    // Kejuruan state
    final kejuruanListAsync = ref.watch(snkKejuruanListProvider(blkId: blkId));
    final selectedKejuruan = useState<SnkKejuruanEntity?>(null);

    // Wilayah cascading state
    final provinsiListAsync = ref.watch(snkProvinsiListProvider);
    final selectedProvinsi = useState<SnkWilayahEntity?>(null);
    final selectedKabKota = useState<SnkWilayahEntity?>(null);
    final selectedKecamatan = useState<SnkWilayahEntity?>(null);
    final selectedKelurahan = useState<SnkWilayahEntity?>(null);

    // Conditional wilayah fetches
    final kabKotaListAsync = selectedProvinsi.value != null
        ? ref.watch(snkKabKotaListProvider(idProvinsi: selectedProvinsi.value!.id))
        : null;

    final kecamatanListAsync = selectedKabKota.value != null
        ? ref.watch(snkKecamatanListProvider(idKabKota: selectedKabKota.value!.id))
        : null;

    final kelurahanListAsync = selectedKecamatan.value != null
        ? ref.watch(snkDesaListProvider(idKecamatan: selectedKecamatan.value!.id))
        : null;

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
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pendaftaran UPT BLK\n$blkName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B8D),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan lengkapi data diri Anda untuk mengikuti program pelatihan vokasi di Balai Latihan Kerja $blkName.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Section: Data Diri Pendaftar
              _buildSectionTitle('Data Diri Pendaftar'),
              const SizedBox(height: 24),

              // Kejuruan dropdown
              _buildKejuruanDropdown(kejuruanListAsync, selectedKejuruan),
              const SizedBox(height: 16),

              SinakerTextField(
                label: 'Nomor KTP (NIK)',
                hintText: 'Masukkan 16 digit NIK',
                keyboardType: TextInputType.number,
                controller: nikController,
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'Nama Lengkap',
                hintText: 'Sesuai KTP',
                controller: namaController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SinakerTextField(
                      label: 'Tempat Lahir',
                      hintText: 'Kota Lahir',
                      controller: tempatLahirController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SinakerTextField(
                      label: 'Tanggal Lahir',
                      hintText: 'YYYY-MM-DD',
                      controller: tanggalLahirController,
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          tanggalLahirController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'Email Aktif',
                hintText: 'example@mail.com',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 16),

              // Gender radio
              const Text(
                'JENIS KELAMIN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'laki_laki',
                      label: Text('Laki-laki', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment<String>(
                      value: 'perempuan',
                      label: Text('Perempuan', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  selected: <String>{gender.value},
                  onSelectionChanged: (Set<String> newSelection) {
                    gender.value = newSelection.first;
                  },
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Wilayah cascading dropdowns
              Row(
                children: [
                  Expanded(
                    child: _buildWilayahDropdown(
                      label: 'Provinsi',
                      asyncValue: provinsiListAsync,
                      selectedValue: selectedProvinsi.value,
                      onChanged: (val) {
                        selectedProvinsi.value = val;
                        selectedKabKota.value = null;
                        selectedKecamatan.value = null;
                        selectedKelurahan.value = null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildWilayahDropdown(
                      label: 'Kab / Kota',
                      asyncValue: kabKotaListAsync,
                      selectedValue: selectedKabKota.value,
                      onChanged: (val) {
                        selectedKabKota.value = val;
                        selectedKecamatan.value = null;
                        selectedKelurahan.value = null;
                      },
                      enabled: selectedProvinsi.value != null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildWilayahDropdown(
                      label: 'Kecamatan',
                      asyncValue: kecamatanListAsync,
                      selectedValue: selectedKecamatan.value,
                      onChanged: (val) {
                        selectedKecamatan.value = val;
                        selectedKelurahan.value = null;
                      },
                      enabled: selectedKabKota.value != null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildWilayahDropdown(
                      label: 'Kelurahan',
                      asyncValue: kelurahanListAsync,
                      selectedValue: selectedKelurahan.value,
                      onChanged: (val) {
                        selectedKelurahan.value = val;
                      },
                      enabled: selectedKecamatan.value != null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SinakerTextField(
                      label: 'RT',
                      hintText: '000',
                      keyboardType: TextInputType.number,
                      controller: rtController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SinakerTextField(
                      label: 'RW',
                      hintText: '000',
                      keyboardType: TextInputType.number,
                      controller: rwController,
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'Alamat Lengkap (Sesuai KTP)',
                hintText: 'Nama Jalan, Blok, No Rumah...',
                controller: alamatController,
              ),

              const SizedBox(height: 32),

              // Section: Informasi Lain
              _buildSectionTitle('Informasi Lain'),
              const SizedBox(height: 24),

              SinakerDropdownField(
                label: 'Penyandang Disabilitas?',
                value: penyandangDisabilitas.value ? 'Ya' : 'Tidak',
                items: const ['Tidak', 'Ya'],
                onChanged: (val) {
                  penyandangDisabilitas.value = val == 'Ya';
                },
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'No. WA Peserta',
                hintText: '0812xxxx',
                keyboardType: TextInputType.phone,
                controller: noWaController,
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'No. WA Wali / Darurat',
                hintText: '0812xxxx',
                keyboardType: TextInputType.phone,
                controller: noWaDaruratController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SinakerDropdownField(
                      label: 'Pendidikan Terakhir',
                      value: pendidikanTerakhir.value,
                      items: const [
                        'tidak_sekolah', 'sd', 'smp', 'sma_smk', 'd3', 's1', 's2', 's3'
                      ],
                      onChanged: (val) {
                        if (val != null) pendidikanTerakhir.value = val;
                      },
                      displayMapper: _pendidikanDisplayName,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SinakerDropdownField(
                      label: 'Pendidikan Sekarang',
                      value: pendidikanSekarang.value,
                      items: const [
                        'tidak_sekolah', 'sd', 'smp', 'sma_smk', 'd3', 's1', 's2', 's3'
                      ],
                      onChanged: (val) {
                        if (val != null) pendidikanSekarang.value = val;
                      },
                      displayMapper: _pendidikanDisplayName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'Asal Sekolah/Universitas',
                hintText: 'Nama Instansi Pendidikan',
                controller: asalSekolahController,
              ),
              const SizedBox(height: 16),
              SinakerTextField(
                label: 'Jurusan',
                hintText: 'Contoh: Multimedia, Akuntansi',
                controller: jurusanController,
              ),
              const SizedBox(height: 16),

              // Photo upload
              const Text(
                'PAS FOTO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    fotoFile.value = File(picked.path);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: fotoFile.value != null ? Colors.green.shade300 : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        fotoFile.value != null ? Icons.check_circle : Icons.camera_alt_outlined,
                        color: fotoFile.value != null ? Colors.green : Colors.grey,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fotoFile.value != null
                            ? fotoFile.value!.path.split('/').last
                            : 'Unggah Foto',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'WAJIB BACKGROUND MERAH',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'File Harus JPG/PNG, Maksimal 2MB',
                        style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting.value
                      ? null
                      : () => _handleSubmit(
                    context: context,
                    ref: ref,
                    blkId: blkId,
                    selectedKejuruan: selectedKejuruan.value,
                    nikController: nikController,
                    namaController: namaController,
                    tempatLahirController: tempatLahirController,
                    tanggalLahirController: tanggalLahirController,
                    emailController: emailController,
                    gender: gender.value,
                    selectedProvinsi: selectedProvinsi.value,
                    selectedKabKota: selectedKabKota.value,
                    selectedKecamatan: selectedKecamatan.value,
                    selectedKelurahan: selectedKelurahan.value,
                    asalSekolahController: asalSekolahController,
                    jurusanController: jurusanController,
                    rtController: rtController,
                    rwController: rwController,
                    alamatController: alamatController,
                    noWaController: noWaController,
                    noWaDaruratController: noWaDaruratController,
                    pendidikanTerakhir: pendidikanTerakhir.value,
                    pendidikanSekarang: pendidikanSekarang.value,
                    penyandangDisabilitas: penyandangDisabilitas.value,
                    fotoFile: fotoFile.value,
                    isSubmitting: isSubmitting,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003B8D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSubmitting.value
                      ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Dengan menekan tombol di atas, saya menyatakan bahwa seluruh data yang diisi adalah benar dan dapat dipertanggungjawabkan sesuai hukum yang berlaku.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: const Color(0xFF003B8D)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildKejuruanDropdown(
    AsyncValue<List<SnkKejuruanEntity>> asyncValue,
    ValueNotifier<SnkKejuruanEntity?> selected,
  ) {
    return asyncValue.when(
      data: (list) {
        if (list.isEmpty) {
          return const SinakerTextField(
            label: 'Kejuruan Pelatihan',
            hintText: 'Tidak ada kejuruan tersedia',
            readOnly: true,
          );
        }

        final items = list.map((e) => e.nama).toList();
        final currentValue = selected.value?.nama ?? items.first;

        // Set initial selection
        if (selected.value == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selected.value = list.first;
          });
        }

        return SinakerDropdownField(
          label: 'Kejuruan Pelatihan',
          value: currentValue,
          items: items,
          onChanged: (val) {
            selected.value = list.firstWhere((e) => e.nama == val);
          },
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KEJURUAN PELATIHAN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(child: SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )),
          ),
        ],
      ),
      error: (_, _) => const SinakerTextField(
        label: 'Kejuruan Pelatihan',
        hintText: 'Gagal memuat kejuruan',
        readOnly: true,
      ),
    );
  }

  Widget _buildWilayahDropdown({
    required String label,
    required AsyncValue<List<SnkWilayahEntity>>? asyncValue,
    required SnkWilayahEntity? selectedValue,
    required ValueChanged<SnkWilayahEntity?> onChanged,
    bool enabled = true,
  }) {
    if (!enabled || asyncValue == null) {
      return SinakerDropdownField(
        label: label,
        value: 'Pilih $label',
        items: ['Pilih $label'],
        onChanged: (_) {},
      );
    }

    return asyncValue.when(
      data: (list) {
        if (list.isEmpty) {
          return SinakerDropdownField(
            label: label,
            value: 'Tidak ada data',
            items: const ['Tidak ada data'],
            onChanged: (_) {},
          );
        }

        const placeholder = '— Pilih —';
        final items = [placeholder, ...list.map((e) => e.nama)];
        final currentValue = selectedValue != null && items.contains(selectedValue.nama)
            ? selectedValue.nama
            : placeholder;

        return SinakerDropdownField(
          label: label,
          value: currentValue,
          items: items,
          onChanged: (val) {
            if (val == null || val == placeholder) {
              onChanged(null);
              return;
            }
            final entity = list.firstWhere((e) => e.nama == val);
            onChanged(entity);
          },
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(child: SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )),
          ),
        ],
      ),
      error: (_, _) => SinakerDropdownField(
        label: label,
        value: 'Gagal memuat',
        items: const ['Gagal memuat'],
        onChanged: (_) {},
      ),
    );
  }

  String _pendidikanDisplayName(String value) {
    switch (value) {
      case 'tidak_sekolah': return 'Tidak Sekolah';
      case 'sd': return 'SD';
      case 'smp': return 'SMP';
      case 'sma_smk': return 'SMA/SMK';
      case 'd3': return 'D3';
      case 's1': return 'S1';
      case 's2': return 'S2';
      case 's3': return 'S3';
      default: return value;
    }
  }

  Future<void> _handleSubmit({
    required BuildContext context,
    required WidgetRef ref,
    required int blkId,
    required SnkKejuruanEntity? selectedKejuruan,
    required TextEditingController nikController,
    required TextEditingController namaController,
    required TextEditingController tempatLahirController,
    required TextEditingController tanggalLahirController,
    required TextEditingController emailController,
    required String gender,
    required SnkWilayahEntity? selectedProvinsi,
    required SnkWilayahEntity? selectedKabKota,
    required SnkWilayahEntity? selectedKecamatan,
    required SnkWilayahEntity? selectedKelurahan,
    required TextEditingController rtController,
    required TextEditingController rwController,
    required TextEditingController alamatController,
    required TextEditingController noWaController,
    required TextEditingController noWaDaruratController,
    required String pendidikanTerakhir,
    required String pendidikanSekarang,
    required bool penyandangDisabilitas,
    required TextEditingController asalSekolahController,
    required TextEditingController jurusanController,
    required File? fotoFile,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    // Validation
    if (selectedKejuruan == null ||
        nikController.text.isEmpty ||
        namaController.text.isEmpty ||
        tempatLahirController.text.isEmpty ||
        tanggalLahirController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedProvinsi == null ||
        selectedKabKota == null ||
        selectedKecamatan == null ||
        selectedKelurahan == null ||
        rtController.text.isEmpty ||
        rwController.text.isEmpty ||
        alamatController.text.isEmpty ||
        noWaController.text.isEmpty ||
        noWaDaruratController.text.isEmpty ||
        asalSekolahController.text.isEmpty ||
        jurusanController.text.isEmpty ||
        fotoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua field yang wajib diisi')),
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final result = await ref.read(
        snkSubmitPendaftaranProvider(
          blkId: blkId,
          kejuruanId: selectedKejuruan.id,
          nik: nikController.text,
          namaLengkap: namaController.text,
          tempatLahir: tempatLahirController.text,
          tanggalLahir: tanggalLahirController.text,
          email: emailController.text,
          jenisKelamin: gender,
          provinsi: selectedProvinsi.nama,
          kabKota: selectedKabKota.nama,
          kecamatan: selectedKecamatan.nama,
          kelurahan: selectedKelurahan.nama,
          asalSekolah: asalSekolahController.text,
          jurusan: jurusanController.text,
          rt: rtController.text,
          rw: rwController.text,
          alamatLengkap: alamatController.text,
          noWa: noWaController.text,
          noWaDarurat: noWaDaruratController.text,
          pendidikanTerakhir: pendidikanTerakhir,
          pendidikanSekarang: pendidikanSekarang,
          penyandangDisabilitas: penyandangDisabilitas,
          foto: fotoFile,
        ).future,
      );

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Pendaftaran Berhasil'),
            content: Text(
              'Status: ${result.status}\n'
              'ID Pendaftaran: ${result.id ?? '-'}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ctx.pop();
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pendaftaran gagal: $e')),
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }
}
