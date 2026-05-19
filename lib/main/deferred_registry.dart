import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../deferred/transjatim/presentation/screens/tj_screen.dart' deferred as transjatim_screen;

/// List of Routes for Deferred Pages and Assets
List<RouteBase> deferredRoutes = [
  GoRoute(
    path: '/transjatim',
    builder: (context, state) => FutureBuilder(
      future: transjatim_screen.loadLibrary(),
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
];