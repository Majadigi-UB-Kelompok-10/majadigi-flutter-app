import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/siskaperbapo_screen.dart' deferred as siskaperbapo_screen;
import 'presentation/screens/siskaperbapo_detail_screen.dart' deferred as siskaperbapo_detail_screen;

// Siskaperbapo screen
final siskaperbapoRoutes = [
  GoRoute(
    path: '/siskaperbapo',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        siskaperbapo_screen.loadLibrary(),
        siskaperbapo_detail_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return siskaperbapo_screen.SiskaperbapoScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/siskaperbapo/detail/:slug',
    builder: (context, state) {
      final slug = state.pathParameters['slug']!;
      return FutureBuilder(
        future: Future.wait([siskaperbapo_detail_screen.loadLibrary(),]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return siskaperbapo_detail_screen.SiskaperbapoDetailScreen(slug: slug);
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    },
  ),
];
