import 'package:flutter/material.dart';

class BapendaCaptcha extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const BapendaCaptcha({
    super.key,
    required this.onChanged,
  });

  @override
  State<BapendaCaptcha> createState() => _BapendaCaptchaState();
}

class _BapendaCaptchaState extends State<BapendaCaptcha> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (v) {
              setState(() => _isChecked = v ?? false);
              widget.onChanged(_isChecked);
            },
          ),
          const Text(
            'Saya bukan robot',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Column(
            children: [
              const Icon(Icons.security, size: 20, color: Colors.grey),
              Text(
                'reCAPTCHA',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey.shade600,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
