import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final String? query;
  const SearchPage({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(query ?? "No Query"),
      ),
    );
  }
}