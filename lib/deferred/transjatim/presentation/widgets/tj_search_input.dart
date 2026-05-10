import 'package:flutter/material.dart';

class TjSearchInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;

  const TjSearchInput({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
