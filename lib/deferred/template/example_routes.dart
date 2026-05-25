// import 'package:go_router/go_router.dart';

/// Defer packages in here and create a List or RouteBase with Go Router
/// then import to deferred_registry in lib/main/deferred_registry.dart

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:majadigi_mobile_rebuild/deferred/{feature}/presentation/screens/{feature}_screen.dart' deferred as {feature}_screen;

// {Feature} Routes
// List<RouteBase> {Feature}Routes = [
//   GoRoute(
//     path: '/{feature}',
//     builder: (context, state) => FutureBuilder(
//       future: Future.wait([
//         // Load all on landing page
//         {feature_a}.loadLibrary(),
//         {feature_b}.loadLibrary(),
//         {feature_c}.loadLibrary(),
//       ]),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(child: Text('Error: ${snapshot.error}')),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return {feature}_screen.{Feature}Screen();
//         }
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       },
//     ),
//   ),
//   GoRoute(
//     path: '/{feature}/detail',
//     builder: (context, state) => FutureBuilder(
//       future: {feature_detail}.loadLibrary(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return {feature_detail}.{Feature}DetailScreen();
//         }
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       },
//     ),
//   ),
// ];