import 'package:flutter/material.dart';
import 'package:majadigi_mobile/ui/deferred/siskaperbapo/widgets/siskaperbapo_form.dart';
import 'package:majadigi_mobile/ui/deferred/siskaperbapo/widgets/siskaperbapo_title_description.dart';

class MySiskaperbapoApp extends StatelessWidget {
  const MySiskaperbapoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi Mobile App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Siskaperbapo(),
    );
  }
}


class Siskaperbapo extends StatelessWidget {
  const Siskaperbapo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Harga Bahan Pokok (SISKAPERBAPO)",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 8.0,
          children: [
            // Header
            TitleDescription(),

            // Form
            SiskaperbapoForm(),
          ],
        ),
      ),
    );
  }
}