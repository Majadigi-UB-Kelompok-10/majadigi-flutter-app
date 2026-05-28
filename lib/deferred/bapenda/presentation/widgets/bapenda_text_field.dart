import 'package:flutter/material.dart';

class BapendaTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isMasked;

  const BapendaTextField({
    super.key,
    required this.hint,
    this.controller,
    this.isMasked = false,
  });

  @override
  State<BapendaTextField> createState() => _BapendaTextFieldState();
}

class _BapendaTextFieldState extends State<BapendaTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isMasked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.black26),
          suffixIcon: widget.isMasked
              ? GestureDetector(
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade500,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
