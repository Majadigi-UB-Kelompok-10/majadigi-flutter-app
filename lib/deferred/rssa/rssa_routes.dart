import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/rssa_screen.dart' deferred as rssa_screen;

// Rssa Routes
final List<RouteBase> rssaRoutes = [
  GoRoute(
    path: '/rssa',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        rssa_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return rssa_screen.RssaScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
];
