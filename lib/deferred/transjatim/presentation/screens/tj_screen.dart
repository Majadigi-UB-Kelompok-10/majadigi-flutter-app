import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import 'tj_search_screen.dart';
import '../widgets/tj_search_input.dart';
import '../widgets/tj_tab_button.dart';
import '../widgets/tj_price_card.dart';

class TjScreen extends StatefulWidget {
  const TjScreen({super.key});

  @override
  State<TjScreen> createState() => _TjScreenState();
}

class _TjScreenState extends State<TjScreen> {
  bool _isLuxurySelected = false;
  late TextEditingController _fromController;
  late TextEditingController _toController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _handleSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field pencarian')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TjSearchScreen(
          fromCity: _fromController.text,
          toCity: _toController.text,
          date: _formatDate(_selectedDate!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER DENGAN GAMBAR BUS ---
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://res.cloudinary.com/duxmv7lnl/image/upload/v1777986341/ntdp0o9wgtz8lijwigug.png'), // Ganti gambar Trans Jatim asli
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7), // Gelap di atas buat logo/teks
                          Colors.black.withOpacity(0.2), // Mulai transparan di tengah
                          Colors.white.withOpacity(1.0), // Menjadi putih di paling bawah (blend ke bg)
                        ],
                        stops: const [0.0, 0.5, 1.0], // Titik poin perubahan warna
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network('https://res.cloudinary.com/duxmv7lnl/image/upload/v1777986506/flurxnfaipmcjobqgane.png', height: 40), // Logo AJAIB
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AJAIB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                Text('Aplikasi Jatim Informasi Bus', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: 'Ayo naik '),
                                TextSpan(
                                  text: 'Trans Jatim!',
                                  style: TextStyle(color: Color(0xFFFFA920)),
                                ),
                                TextSpan(text: '\nKe mana tujuanmu sekarang?'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- KARTU PENCARIAN (OVERLAP) ---
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('One-way', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.jdihBlue)),
                    const SizedBox(height: 15),
                    TjSearchInput(
                      icon: Icons.location_on_outlined,
                      hint: 'Titik Penjemputan',
                      controller: _fromController,
                    ),
                    const SizedBox(height: 10),
                    TjSearchInput(
                      icon: Icons.directions_bus_outlined,
                      hint: 'Stasiun Tujuan',
                      controller: _toController,
                    ),
                    const SizedBox(height: 10),
                    _buildDateInput(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.jdihBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: _handleSearch,
                        child: const Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // --- INFORMASI HARGA TIKET ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Harga Tiket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TjTabButton(
                          label: 'Layanan Reguler',
                          isActive: !_isLuxurySelected,
                          onTap: () => setState(() => _isLuxurySelected = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TjTabButton(
                          label: 'Layanan Luxury',
                          isActive: _isLuxurySelected,
                          onTap: () => setState(() => _isLuxurySelected = true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_isLuxurySelected) ...[
                    TjPriceCard(
                      type: 'SBY-GSK Luxury',
                      price: '20,000',
                      description: 'Fasilitas: Kursi premium (tanpa berdiri) dan AC ekstra dingin.',
                      color: Colors.blue,
                    ),
                    TjPriceCard(
                      type: 'SBY-SDA Luxury',
                      price: '15,000',
                      description: 'Fasilitas: Kursi premium (tanpa berdiri) dan AC ekstra dingin.',
                      color: Colors.blue,
                    ),
                    TjPriceCard(
                      type: 'SDA-GSK Luxury',
                      price: '30,000',
                      description: 'Fasilitas: Kursi premium (tanpa berdiri) dan AC ekstra dingin.',
                      color: Colors.blue,
                    ),
                  ] else ...[
                    TjPriceCard(
                      type: 'Umum',
                      price: '5,000',
                      description: 'Penumpang dewasa/umum.',
                      color: Colors.blue,
                    ),
                    TjPriceCard(
                      type: 'Pelajar/Santri',
                      price: '2,500',
                      description: 'Menunjukkan kartu pelajar atau berseragam.',
                      color: Colors.green,
                    ),
                    TjPriceCard(
                      type: 'Mahasiswa',
                      price: '2,500',
                      description: 'Menunjukkan Kartu Tanda Mahasiswa (KTM).',
                      color: Colors.orange,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildDateInput() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? now,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 2),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Text(_selectedDate != null ? _formatDate(_selectedDate!) : 'Sat, April 4')
              ]),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade100), borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('+ Add return', style: TextStyle(color: Colors.grey))),
          ),
        ),
      ],
    );
  }
}
