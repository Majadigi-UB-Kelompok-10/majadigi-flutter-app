import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/jdih_screen.dart' deferred as jdih_screen;
import 'presentation/jdih_search_screen.dart' deferred as jdih_search_screen;
import 'presentation/jdih_detail_screen.dart' deferred as jdih_detail_screen;
import 'presentation/jdih_category_screen.dart' deferred as jdih_category_screen;

// JDIH Routes
final List<RouteBase> jdihRoutes = [
  GoRoute(
    path: '/produk-hukum-jawa-timur',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        jdih_screen.loadLibrary(),
        jdih_search_screen.loadLibrary(),
        jdih_detail_screen.loadLibrary(),
        jdih_category_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return jdih_screen.JdihScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/jdih/search',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        jdih_screen.loadLibrary(),
        jdih_search_screen.loadLibrary(),
        jdih_detail_screen.loadLibrary(),
        jdih_category_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (state.extra == null) {
            if (context.mounted) {
              context.pop();
            }

            return const SizedBox.shrink();
          }

          final data = state.extra as Map<String, dynamic>?;

          return jdih_search_screen.JdihSearchScreen(
            initialKeyword: data?["initialKeyword"],
            initialJenis: data?["initialJenis"],
            initialTahun: data?["initialTahun"],
            initialNomor: data?["initialNomor"],
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/jdih/category',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        jdih_screen.loadLibrary(),
        jdih_search_screen.loadLibrary(),
        jdih_detail_screen.loadLibrary(),
        jdih_category_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (state.extra == null) {
            if (context.mounted) {
              context.pop();
            }

            return const SizedBox.shrink();
          }

          final data = state.extra as Map<String, dynamic>;

          return jdih_category_screen.JdihCategoryScreen(
            jenisValue: data["jenisValue"],
            jenisLabel: data["jenisLabel"]
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/jdih/detail',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        jdih_screen.loadLibrary(),
        jdih_search_screen.loadLibrary(),
        jdih_detail_screen.loadLibrary(),
        jdih_category_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (state.extra == null) {
            if (context.mounted) {
              context.pop();
            }

            return const SizedBox.shrink();
          }

          final data = state.extra as Map<String, dynamic>;

          return jdih_detail_screen.JdihDetailScreen(
            documentId: data["documentId"]
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
];
