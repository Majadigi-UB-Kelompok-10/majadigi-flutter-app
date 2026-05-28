import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/klinik_hoaks_main_screen.dart' deferred as kh_main;
import 'presentation/screens/klinik_hoaks_detail_screen.dart' deferred as kh_detail;
import 'presentation/screens/klinik_hoaks_report_screen.dart' deferred as kh_report;
import 'presentation/screens/klinik_hoaks_track_screen.dart' deferred as kh_track;

// Klinik Hoaks Routes
final List<RouteBase> klinikHoaksRoutes = [
  GoRoute(
    path: '/klinik-hoaks',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        kh_main.loadLibrary(),
        kh_detail.loadLibrary(),
        kh_report.loadLibrary(),
        kh_track.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return kh_main.KlinikHoaksMainScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/klinik-hoaks/detail/:slug',
    builder: (context, state) => FutureBuilder(
      future: kh_detail.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final slug = state.pathParameters['slug'] ?? '';
          return kh_detail.KlinikHoaksDetailScreen(slug: slug);
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/klinik-hoaks/report',
    builder: (context, state) => FutureBuilder(
      future: kh_report.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return kh_report.KlinikHoaksReportScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/klinik-hoaks/track',
    builder: (context, state) => FutureBuilder(
      future: kh_track.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return kh_track.KlinikHoaksTrackScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
];
