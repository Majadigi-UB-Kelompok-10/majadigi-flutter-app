import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/bansos/presentation/screens/bansos_screen.dart' deferred as bansos_screen;
import 'package:majadigi_mobile_rebuild/deferred/bansos/presentation/screens/bansos_info_screen.dart' deferred as bansos_info_screen;
import 'package:majadigi_mobile_rebuild/deferred/bansos/presentation/screens/bansos_detail_screen.dart' deferred as bansos_detail_screen;

/// Bansos Routes
List<RouteBase> bansosRoutes = [
  GoRoute(
    path: '/sapabansos',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        // Load all on landing page
        bansos_screen.loadLibrary(),
        bansos_info_screen.loadLibrary(),
        bansos_detail_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return bansos_screen.BansosScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/sapabansos/info',
    builder: (context, state) => FutureBuilder(
      future: bansos_info_screen.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final nik = state.extra as String? ?? '';
          return bansos_info_screen.BansosInfoScreen(nik: nik);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/sapabansos/detail',
    builder: (context, state) => FutureBuilder(
      future: bansos_detail_screen.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // Since as type cannot be done without importing here, using dynamic..
          final data = state.extra as dynamic;
          return bansos_detail_screen.BansosDetailScreen(benefit: data);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
];