import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../deferred/transjatim/presentation/screens/tj_screen.dart' deferred as transjatim_screen;
import '../deferred/transjatim/presentation/screens/tj_search_screen.dart' deferred as transjatim_search;
import '../deferred/transjatim/presentation/screens/tj_detail_screen.dart' deferred as transjatim_detail;
import '../deferred/bansos/presentation/screens/bansos_screen.dart' deferred as bansos_screen;
import '../deferred/bansos/presentation/screens/bansos_info_screen.dart' deferred as bansos_info_screen;
import '../deferred/bansos/presentation/screens/bansos_detail_screen.dart' deferred as bansos_detail_screen;


/// List of Routes for Deferred Pages and Assets
List<RouteBase> deferredRoutes = [
  ...transjatimRoutes,
  ...bansosRoutes,
];

/// Transjatim Routes
List<RouteBase> transjatimRoutes = [
  GoRoute(
    path: '/transjatim',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        // Load all on landing page
        transjatim_screen.loadLibrary(),
        transjatim_search.loadLibrary(),
        transjatim_detail.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return transjatim_screen.TjScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/transjatim/search',
    builder: (context, state) => FutureBuilder(
      future: transjatim_search.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return transjatim_search.TjSearchScreen(
            fromTerminalId: data['fromTerminalId'] ?? '',
            toTerminalId: data['toTerminalId'] ?? '',
            fromTerminal: data['fromTerminal'] ?? '',
            toTerminal: data['toTerminal'] ?? '',
            date: data['date'] ?? '',
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/transjatim/detail',
    builder: (context, state) => FutureBuilder(
      future: transjatim_detail.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = state.extra as Map<String, dynamic>? ?? {};

          return transjatim_detail.TjDetailScreen(
            search: data['schedule'],
            fromTerminal: data['fromTerminal'] ?? '',
            toTerminal: data['toTerminal'] ?? '',
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
];

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
