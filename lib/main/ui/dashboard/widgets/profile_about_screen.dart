import 'package:flutter/material.dart';

class AccountAboutScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AccountAboutScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About', 
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
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                child: const Text('About Majadigi Jatim', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 12),
              Container(
                child: const Text('Majadigi Jatim is a digital platform developed to support innovation, collaboration, and digital transformation across East Java. The app serves as a centralized hub for users to access information, services, and digital initiatives efficiently.', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 20),
              Container(
                child: const Text('Our Mission', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 12),
              Container(
                child: const Text('To empower communities and organizations through accessible, reliable, and innovative digital solutions.', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 20),
              Container(
                child: const Text('Our Vision', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 12),
              Container(
                child: const Text('To become a leading digital ecosystem that accelerates growth and connectivity in East Java.', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 20),
              Container(  
                child: const Text('Key Features', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 12),
              Container(
                child: const Text('   • Access to digital services and programs,\n'
                '   • Information on regional innovation initiatives,\n'
                '   • User-friendly interface for seamless navigation,\n'
                '   • Secure and reliable data management.', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 20),
              Container(
                child: const Text('Version Information', 
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
              const SizedBox(height: 12),
              Container(
                child: const Text('   • App Version   : 1.0.0\n'
                '   • Last Updated : April 2026',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}