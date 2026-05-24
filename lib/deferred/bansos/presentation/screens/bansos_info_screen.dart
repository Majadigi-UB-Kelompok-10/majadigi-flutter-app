import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:majadigi_mobile_rebuild/deferred/theme/app_theme.dart';
import '../widgets/bansos_card.dart';
import '../../core/providers/bansos_providers.dart';
import '../../domain/entities/bansos/bansos_entity.dart';

class BansosInfoScreen extends ConsumerWidget {
  final String nik;

  const BansosInfoScreen({super.key, required this.nik});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchBansosAsync = ref.watch(watchBansosInfoProvider(nik));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.jdihBlue,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Info Bansos',
                          style: TextStyle(
                            color: AppTheme.jdihBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            Expanded(
              child: watchBansosAsync.when(
                data: (data) => _buildContent(context, data.firstOrNull),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.jdihBlue),
                ),
                error: (error, stack) => Center(
                  child: Text('Terjadi kesalahan: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BansosEntity? data) {
    final found = data != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        _StatusBanner(found: found),
        const SizedBox(height: 16),
        if (found) _IdentityCard(identity: data.profil),
        const SizedBox(height: 16),
        if (found)
          ...data.riwayat.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BansosBenefitCard(
                benefit: benefit,
                onTap: () {
                  if (context.mounted) {
                    context.push("/sapabansos/detail", extra: benefit);
                  }
                },
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Data bantuan sosial tidak ditemukan untuk NIK ini.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final ProfilEntity identity;

  const _IdentityCard({required this.identity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            identity.nama,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Nama', value: identity.nama),
          const SizedBox(height: 8),
          _InfoRow(label: 'Alamat', value: identity.alamat),
          const SizedBox(height: 8),
          _InfoRow(label: 'NIK', value: identity.nik),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final bool found;

  const _StatusBanner({required this.found});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: found ? const Color(0xFFB7E8CF) : const Color(0xFFFECACA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            found ? Icons.assignment_turned_in_outlined : Icons.highlight_off_rounded,
            color: found ? const Color(0xFF166534) : const Color(0xFFB91C1C),
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            found ? 'Data ditemukan' : 'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: found ? const Color(0xFF166534) : const Color(0xFFB91C1C),
            ),
          ),
        ],
      ),
    );
  }
}
