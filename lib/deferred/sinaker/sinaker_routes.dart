import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/sinaker_main_screen.dart' deferred as sinaker_main_screen;
import 'presentation/screens/sinaker_register_screen.dart' deferred as sinaker_register_screen;
import 'presentation/screens/sinaker_status_screen.dart' deferred as sinaker_status_screen;

// Sinaker screen
final sinakerRoutes = [
  GoRoute(
    path: '/daftar-pelatihan-kerja',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sinaker_main_screen.loadLibrary(),
        sinaker_register_screen.loadLibrary(),
        sinaker_status_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sinaker_main_screen.SinakerMainScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/balai-latihan-kerja',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sinaker_main_screen.loadLibrary(),
        sinaker_register_screen.loadLibrary(),
        sinaker_status_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sinaker_main_screen.SinakerMainScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/balai-latihan-kerja/daftar',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sinaker_main_screen.loadLibrary(),
        sinaker_register_screen.loadLibrary(),
        sinaker_status_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (state.extra == null) {
            if (context.mounted) {
              context.pop();
            }

            return const SizedBox.shrink();
          }

          final data = state.extra as Map<String, dynamic>;
          final blkId = data["blkId"];
          final blkName = data["blkName"];

          if (blkId == null || blkName == null) {
            return const SizedBox.shrink();
          }

          return sinaker_register_screen.SinakerRegisterScreen(blkId: blkId, blkName: blkName);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
  GoRoute(
    path: '/cek-pendaftaran-pelatihan-kerja',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        sinaker_status_screen.loadLibrary()
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return sinaker_status_screen.SinakerStatusScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  ),
];
