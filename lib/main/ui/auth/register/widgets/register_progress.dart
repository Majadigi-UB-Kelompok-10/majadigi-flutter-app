import 'package:flutter/material.dart';

class RegisterProgress extends StatelessWidget {
  const RegisterProgress({super.key, this.step = 1, this.total = 2});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
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
