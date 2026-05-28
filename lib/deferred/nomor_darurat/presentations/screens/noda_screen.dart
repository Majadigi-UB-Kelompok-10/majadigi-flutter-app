import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../widgets/noda_header.dart';

class NodaScreen extends StatefulWidget {
  const NodaScreen({super.key});

  @override
  State<NodaScreen> createState() => _NodaScreenState();
}

class _NodaScreenState extends State<NodaScreen> {
  String _selectedProvince = 'Jawa Timur';

  static const List<_NodaItem> _noda = [
    _NodaItem(
      icon: Icons.local_taxi_outlined,
      title: 'Ambulace',
      number: '1185',
      color: Color(0xFFE91E63),
    ),
    _NodaItem(
      icon: Icons.security_outlined,
      title: 'Polisi',
      number: '110',
      color: Color(0xFF1E3A8A),
    ),
    _NodaItem(
      icon: Icons.local_taxi_outlined,
      title: 'Taksi Argo',
      number: '488888',
      color: Color(0xFF4CAF50),
    ),
    _NodaItem(
      icon: Icons.local_taxi_outlined,
      title: 'Taksi Citra',
      number: '490555',
      color: Color(0xFF4CAF50),
    ),
    _NodaItem(
      icon: Icons.shield_outlined,
      title: 'Posko Kewaspadaan',
      number: '1223',
      color: Color(0xFF1E3A8A),
    ),
    _NodaItem(
      icon: Icons.local_fire_department_outlined,
      title: 'Pemadan Kebakaran',
      number: '3646176',
      color: Color(0xFFC41C3B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: Column(
        children: [
          // Header dengan JdihHeader
        NodaHeader(
          height: 340, // Sesuaikan sedikit tingginya jika dropdown terpotong
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Tombol back tetap di atas
            children: [
              // 1. Tombol Back (Tetap di kiri sendirian)
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                ),
              ),
              
              const SizedBox(width: 12),

              // 2. KONTEN UTAMA (Logo, Judul, Deskripsi, Dropdown)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Kunci agar semua rata kiri mengikuti logo
                  children: [
                    // Baris Logo + Judul
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: AppTheme.jdihBlue,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Nomor Darurat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Dinas Komunikasi & Informatika',
                                style: TextStyle(
                                  color: Color(0xFFB9D1EE),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Deskripsi (Otomatis sejajar di bawah logo telepon)
                    const Padding(
                      padding: EdgeInsets.only(right: 54), // Memberi jarak agar tidak mepet layar kanan
                      child: Text(
                        'Nomor darurat merupakan layanan cepat tanggal dari pemerintah atau instansi terkait untuk memberikan bantuan kepada masyarakat. Nomor ini dapat dihubungi saat warga menghadapi situasi mendesak, berbahaya, atau yang mengancam jiwa.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Color(0xFFE0E7FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Dropdown Provinsi (Juga sejajar di bawah logo)
                    Padding(
                      padding: const EdgeInsets.only(right: 54),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: DropdownButton<String>(
                          value: _selectedProvince,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.expand_more, color: Color(0xFF6B7280)),
                          items: const [
                            DropdownMenuItem(value: 'Jawa Timur', child: Text('Jawa Timur')),
                            DropdownMenuItem(value: 'Jawa Tengah', child: Text('Jawa Tengah')),
                            DropdownMenuItem(value: 'Jawa Barat', child: Text('Jawa Barat')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedProvince = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          // Grid Nomor Darurat
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate width for 2 columns.
                  // We subtract the crossAxisSpacing (16) and divide by 2.
                  final double itemWidth = (constraints.maxWidth - 16) / 2;

                  return Wrap(
                    spacing: 16, // Equivalent to crossAxisSpacing
                    runSpacing: 16, // Equivalent to mainAxisSpacing
                    children: _noda.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        // The height will dynamically adjust to your content!
                        child: _NodaCard(item: item),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NodaCard extends StatelessWidget {
  final _NodaItem item;

  const _NodaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kecil seperti pada JDIH cards
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          // Number
          Text(
            item.number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          // Call Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () async {
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: item.number,
                );

                final bool didLaunch = await launchUrl(phoneUri);

                if (!didLaunch && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal Membuka Dialer untuk ${item.number}')),
                  );
                }
              },
              icon: const Icon(Icons.phone, size: 18),
              label: const Text(
                'Hubungi Sekarang',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC41C3B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NodaItem {
  final IconData icon;
  final String title;
  final String number;
  final Color color;

  const _NodaItem({
    required this.icon,
    required this.title,
    required this.number,
    required this.color,
  });
}
