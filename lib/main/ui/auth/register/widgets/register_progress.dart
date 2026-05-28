import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/ui/auth/register/provider/register_nav_index_provider.dart';

class RegisterProgress extends ConsumerWidget {
  final int total;
  const RegisterProgress({super.key, this.total = 2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(registerNavIndexProvider);
    final step = index + 1;
    
    final double fraction = (step / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A63D2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Langkah $step dari $total',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF34546B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
