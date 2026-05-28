import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/deferred/bapenda/presentation/screens/bapenda_screen.dart'
    deferred as bapenda_screen;

List<RouteBase> bapendaRoutes = [
  GoRoute(
    path: '/pajak-kendaraan',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        bapenda_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return bapenda_screen.BapendaScreen(
            index: 0,
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
  GoRoute(
    path: '/nilai-jual-kendaraan-bermotor',
    builder: (context, state) => FutureBuilder(
      future: Future.wait([
        bapenda_screen.loadLibrary(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return bapenda_screen.BapendaScreen(
            index: 1,
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    ),
  ),
];
