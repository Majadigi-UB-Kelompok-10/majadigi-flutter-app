import 'package:flutter/material.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Daftar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17304E),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Lengkapi data diri Anda untuk memulai layanan\npemerintah digital.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF59697F),
          ),
        ),
      ],
    );
  }
}
