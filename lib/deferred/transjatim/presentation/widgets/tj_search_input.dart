import 'package:flutter/material.dart';

class TjSearchInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final VoidCallback? onTap;

  const TjSearchInput({
    super.key,
    required this.icon,
    required this.hint,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value != null && value!.isNotEmpty ? value! : hint,
                style: TextStyle(
                  fontSize: 14,
                  color: value != null && value!.isNotEmpty ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
