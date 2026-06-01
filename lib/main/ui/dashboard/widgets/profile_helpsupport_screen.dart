import 'package:flutter/material.dart';

class AccountHelpsupportScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AccountHelpsupportScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support', 
          style: TextStyle(color: Color(0xFF0652C5), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.reply, color: Color(0xFF0652C5)),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text('Welcome to the Help & Support section of Majadigi Jatim. We’re here to assist you in getting the best experience from the app.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('Frequently Asked Questions (FAQ)',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('1. How do I create an account?\nTap on the “Sign Up” button on the login screen, fill in your details, and follow the verification steps.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('2. I forgot my password. What should I do?\nClick “Forgot Password” on the login page and follow the instructions to reset your password via email.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('3. Why can’t I access certain features?\nSome features may require account verification or a stable internet connection. Make sure your app is updated to the latest version.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('4. How do I report a problem or bug?\nYou can report issues through the “Contact Support” section or send us an email with screenshots and a description of the problem.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('5. Is my data secure?\nYes, we prioritize user privacy and use secure systems to protect your personal information.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('Contact Support',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('If you need further assistance, feel free to reach out:',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('   • Email: support@majadigi.jatim.go.id\n'
              '   • Phone: +62 31 1234 5678\n'
              '   • Support Hours: Monday – Friday,\n     08:00 – 16:00 WIB',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 12),
              const Text('We aim to respond to all inquiries within 1–2 business days.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}