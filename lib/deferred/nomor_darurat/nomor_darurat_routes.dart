import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/nomor_darurat/presentations/screens/noda_screen.dart' deferred as noda_screen;

/// Nomor darurat Routes
List<RouteBase> nomorDaruratRoutes = [
  GoRoute(
    path: '/nodajatim',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([noda_screen.loadLibrary()]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return noda_screen.NodaScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
];