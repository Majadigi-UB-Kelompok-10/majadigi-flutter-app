import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/core/providers/tj_providers.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/terminal/tj_terminal_entity.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/ticket/tj_ticket_entity.dart';
import 'package:majadigi_mobile_rebuild/main/core/storage.dart';
import '../widgets/tj_search_input.dart';
import '../widgets/tj_tab_button.dart';
import '../widgets/tj_price_card.dart';

/// Main landing screen for the Trans Jatim module.
class TjScreen extends HookConsumerWidget {
  const TjScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLuxurySelected = useState(false);
    final fromTerminal = useState<TjTerminalEntity?>(null);
    final toTerminal = useState<TjTerminalEntity?>(null);
    final selectedDate = useState<DateTime?>(DateTime.now());

    final ticketsAsync = ref.watch(tjTicketsProvider);
    final terminalAsync = ref.watch(tjTerminalsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TjHeader(cacheStorage: ref.watch(getCustomCacheManagerProvider)),
            _TjSearchCard(
              fromTerminal: fromTerminal,
              toTerminal: toTerminal,
              selectedDate: selectedDate,
              terminalAsync: terminalAsync,
            ),
            _TjTicketSection(
              isLuxurySelected: isLuxurySelected,
              ticketsAsync: ticketsAsync,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header with background image + branding
// ---------------------------------------------------------------------------

class _TjHeader extends StatelessWidget {
  final dynamic cacheStorage;
  const _TjHeader({required this.cacheStorage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://res.cloudinary.com/duxmv7lnl/image/upload/v1777986341/ntdp0o9wgtz8lijwigug.png',
                cacheManager: cacheStorage,
              ),
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
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 1.0),
                ],
                stops: const [0.0, 0.5, 1.0],
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
                    CachedNetworkImage(
                      imageUrl: 'https://res.cloudinary.com/duxmv7lnl/image/upload/v1777986506/flurxnfaipmcjobqgane.png',
                      height: 40,
                      useOldImageOnUrlChange: true,
                      cacheManager: cacheStorage,
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AJAIB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Aplikasi Jatim Informasi Bus', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Ayo naik '),
                        TextSpan(text: 'Trans Jatim!', style: TextStyle(color: Color(0xFFFFA920))),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Search card (overlapping header)
// ---------------------------------------------------------------------------

class _TjSearchCard extends StatelessWidget {
  final ValueNotifier<TjTerminalEntity?> fromTerminal;
  final ValueNotifier<TjTerminalEntity?> toTerminal;
  final ValueNotifier<DateTime?> selectedDate;
  final AsyncValue<List<TjTerminalEntity>> terminalAsync;

  const _TjSearchCard({
    required this.fromTerminal,
    required this.toTerminal,
    required this.selectedDate,
    required this.terminalAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
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
              value: fromTerminal.value?.nama,
              onTap: () => _showTerminalPicker(context, fromTerminal),
            ),
            const SizedBox(height: 10),
            TjSearchInput(
              icon: Icons.directions_bus_outlined,
              hint: 'Stasiun Tujuan',
              value: toTerminal.value?.nama,
              onTap: () => _showTerminalPicker(context, toTerminal),
            ),
            const SizedBox(height: 10),
            _DateInput(selectedDate: selectedDate),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.jdihBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => _handleSearch(context),
                child: const Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTerminalPicker(BuildContext context, ValueNotifier<TjTerminalEntity?> selected) {
    terminalAsync.whenData((terminals) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            minChildSize: 0.3,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Pilih Terminal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: terminals.length,
                      itemBuilder: (context, index) {
                        final terminal = terminals[index];
                        return ListTile(
                          title: Text(terminal.nama ?? ''),
                          subtitle: Text(terminal.kota ?? ''),
                          onTap: () {
                            selected.value = terminal;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  void _handleSearch(BuildContext context) {
    if (fromTerminal.value == null || toTerminal.value == null || selectedDate.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field pencarian')),
      );
      return;
    }

    final date = selectedDate.value!;
    context.push(
      '/transjatim/search',
      extra: {
        'fromTerminalId': fromTerminal.value!.id.toString(),
        'toTerminalId': toTerminal.value!.id.toString(),
        'fromTerminal': fromTerminal.value!.nama,
        'toTerminal': toTerminal.value!.nama,
        'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Date input row
// ---------------------------------------------------------------------------

class _DateInput extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDate;
  const _DateInput({required this.selectedDate});

  static String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate.value ?? now,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 2),
              );
              if (picked != null) selectedDate.value = picked;
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade100),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(selectedDate.value != null ? _formatDate(selectedDate.value!) : '01 April 2026'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('+ Add return', style: TextStyle(color: Colors.grey))),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Ticket pricing section
// ---------------------------------------------------------------------------

class _TjTicketSection extends StatelessWidget {
  final ValueNotifier<bool> isLuxurySelected;
  final AsyncValue<List<TjTicketEntity>> ticketsAsync;

  const _TjTicketSection({
    required this.isLuxurySelected,
    required this.ticketsAsync,
  });

  Color _getTicketColor(String? tipePenumpang) {
    switch (tipePenumpang?.toLowerCase()) {
      case 'pelajar':
      case 'pelajar/santri':
      case 'pelajar_santri':
        return Colors.green;
      case 'mahasiswa':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  isActive: !isLuxurySelected.value,
                  onTap: () => isLuxurySelected.value = false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TjTabButton(
                  label: 'Layanan Luxury',
                  isActive: isLuxurySelected.value,
                  onTap: () => isLuxurySelected.value = true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ticketsAsync.when(
            data: (tickets) {
              final filtered = tickets.where((t) {
                final layanan = t.layanan?.toLowerCase() ?? '';
                return isLuxurySelected.value
                    ? layanan.contains('luxury')
                    : !layanan.contains('luxury');
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No Ticket Available"));
              }

              return Column(
                children: filtered.map((ticket) {
                  final isLuxury = (ticket.layanan?.toLowerCase() ?? '') == 'luxury';
                  final type = isLuxury
                      ? ticket.ruteNama ?? 'Luxury'
                      : ticket.tipePenumpang ?? 'Umum';
                  final description = isLuxury
                      ? ticket.fasilitas ?? ''
                      : ticket.keterangan ?? '';
                  final color = _getTicketColor(ticket.tipePenumpang);

                  return TjPriceCard(
                    type: type,
                    price: ticket.harga?.toStringAsFixed(0) ?? '0',
                    description: description,
                    color: color,
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (e, st) => Text("Error: ${e.toString()}"),
          ),
        ],
      ),
    );
  }
}
