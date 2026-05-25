// =============================================================================
// TEMPLATE: presentation/screens/{prefix}_screen.dart
// Replace {prefix}, {Prefix}, {module_name} with your module values.
// =============================================================================

// TODO: Import providers and widgets
// import 'package:majadigi_mobile_rebuild/deferred/{module_name}/core/providers/{prefix}_providers.dart';

/// Main screen for the {module_name} module.
/// Uses HookConsumerWidget to combine Flutter Hooks (local state) + Riverpod (data).
// class {Prefix}Screen extends HookConsumerWidget {
//   const {Prefix}Screen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // --- Local UI state (Flutter Hooks) ---
//     final isLoading = useState(false);
//
//     // --- Data from providers (Riverpod) ---
//     // final dataAsync = ref.watch({prefix}{Feature}Provider);
//
//     // --- or watch for SWR (Preferred) ---
//     // final watchDataAsync = ref.watch(watch{prefix}{Feature}Provider);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- Example: consuming async provider data ---
//             // dataAsync.when(
//             //   data: (items) {
//             //     return ListView.builder(
//             //       shrinkWrap: true,
//             //       physics: const NeverScrollableScrollPhysics(),
//             //       itemCount: items.length,
//             //       itemBuilder: (context, index) {
//             //         final item = items[index];
//             //         return ListTile(
//             //           title: Text(item.name ?? ''),
//             //         );
//             //       },
//             //     );
//             //   },
//             //   loading: () => const Center(child: CircularProgressIndicator()),
//             //   error: (e, st) => Text('Error: $e'),
//             // ),
//
//             const Center(child: Text('Template Screen')),
//           ],
//         ),
//       ),
//     );
//   }
// }
