import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputFormatter? formatter;
  final TextInputType? keyboardType;
  final Widget? prefix;
  const RegisterInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.formatter,
    this.keyboardType,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: <TextInputFormatter>[?formatter],
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFBBC5D6)),
        filled: true,
        fillColor: const Color(0xFFF3F5FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD7DEEA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0A63D2), width: 1.2),
        ),
        prefixIcon: prefix,
      ),
    );
  }
}
