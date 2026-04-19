import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Create a shell for routing with Material or Cupertino
/// Handles whether the app is Android or IoS
class RouterShell extends StatelessWidget {
  const RouterShell({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Majadigi Mobile App',
        home: CupertinoPageScaffold(
          // TODO: Put your page here
          child: const Center(
            child: const Text('Not Yet Implemented'),
          )
        ),
      );
    }

    return MaterialApp(
      title: 'Majadigi Mobile App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        // TODO: Put your page here
      ),
    );
  }
}