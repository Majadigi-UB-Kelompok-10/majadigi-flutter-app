// =============================================================================
// TEMPLATE: presentation/widgets/{prefix}_{widget_name}.dart
// Replace {prefix}, {Prefix} with your module values.
// Reusable widget — receives data via constructor, not providers.
// =============================================================================

import 'package:flutter/material.dart';

/// A reusable widget for the module.
/// Accepts data and callbacks via constructor — no direct Riverpod access.
// class {Prefix}ExampleWidget extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final VoidCallback? onTap;
//
//   const {Prefix}ExampleWidget({
//     super.key,
//     required this.title,
//     this.subtitle,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.blue.shade100),
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                   if (subtitle != null)
//                     Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
