import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Masuk',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17304E),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Akses layanan publik di Jawa Timur\nlebih mudah dalam satu aplikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: Color(0xFF59697F),
          ),
        ),
      ],
    );
  }
}