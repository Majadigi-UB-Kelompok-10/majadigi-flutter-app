import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/transjatim/domain/entities/search/tj_search_entity.dart';
import '../deferred/transjatim/presentation/screens/tj_screen.dart' deferred as transjatim_screen;
import '../deferred/transjatim/presentation/screens/tj_search_screen.dart' deferred as transjatim_search;
import '../deferred/transjatim/presentation/screens/tj_detail_screen.dart' deferred as transjatim_detail;

/// List of Routes for Deferred Pages and Assets
List<RouteBase> deferredRoutes = [
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
            search: data['schedule'] as TjSearchEntity,
            fromTerminal: data['fromTerminal'] ?? '',
            toTerminal: data['toTerminal'] ?? '',
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
];