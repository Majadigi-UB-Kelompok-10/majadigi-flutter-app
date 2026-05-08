import 'package:flutter/material.dart';
import 'package:majadigi_mobile_rebuild/main/ui/sandbox/sandbox.dart';

/// Create a shell for routing with Material
class RouterShell extends StatelessWidget {
  const RouterShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi Mobile App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Sandbox(),
    );
  }
}