import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/sidita_main_screen.dart' deferred as sidita_main_screen;
import 'presentation/screens/sidita_destination_screen.dart' deferred as sidita_destination_screen;
import 'presentation/screens/sidita_destination_detail_screen.dart' deferred as sidita_destination_detail_screen;
import 'presentation/screens/sidita_hotel_screen.dart' deferred as sidita_hotel_screen;
import 'presentation/screens/sidita_hotel_detail_screen.dart' deferred as sidita_hotel_detail_screen;
import 'presentation/screens/sidita_event_screen.dart' deferred as sidita_event_screen;
import 'presentation/screens/sidita_event_detail_screen.dart' deferred as sidita_event_detail_screen;

/// SIDITA Routes — all screens use deferred loading for code splitting.
final siditaRoutes = [
  // Main landing page
  GoRoute(
    path: '/sidita',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sidita_main_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sidita_main_screen.SiditaMainScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),

  // Destination list
  GoRoute(
    path: '/sidita/destinasi',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sidita_destination_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sidita_destination_screen.SiditaDestinationScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),

  // Destination detail
  GoRoute(
    path: '/sidita/destinasi/:id',
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
      return FutureBuilder(
        future: Future.wait([
          sidita_destination_detail_screen.loadLibrary(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return sidita_destination_detail_screen.SiditaDestinationDetailScreen(id: id);
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    },
  ),

  // Hotel list
  GoRoute(
    path: '/sidita/hotel',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sidita_hotel_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sidita_hotel_screen.SiditaHotelScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),

  // Hotel detail
  GoRoute(
    path: '/sidita/hotel/:id',
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
      return FutureBuilder(
        future: Future.wait([
          sidita_hotel_detail_screen.loadLibrary(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return sidita_hotel_detail_screen.SiditaHotelDetailScreen(id: id);
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    },
  ),

  // Event list
  GoRoute(
    path: '/sidita/event',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sidita_event_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sidita_event_screen.SiditaEventScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),

  // Event detail
  GoRoute(
    path: '/sidita/event/:id',
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
      return FutureBuilder(
        future: Future.wait([
          sidita_event_detail_screen.loadLibrary(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return sidita_event_detail_screen.SiditaEventDetailScreen(id: id);
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    },
  ),
];
