import 'package:flutter/material.dart';

class ServiceStatusBadge extends StatelessWidget {
  const ServiceStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -18,
      right: -15,
      child: Container(
        width: 25,
        height: 25,
        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      ),
    );
  }
}

class EditActionBadge extends StatelessWidget {
  final bool isFavorite;
  const EditActionBadge({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -18,
      right: -15,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: isFavorite ? Colors.red : Colors.green,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Icon(
          isFavorite ? Icons.remove : Icons.add,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}