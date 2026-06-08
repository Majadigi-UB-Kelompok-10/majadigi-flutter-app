import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi_mobile_rebuild/main/core/router.dart' show goRoutes;

void main() {
  late GoRoute pageDetailRoute;

  setUpAll(() {
    final route = goRoutes.whereType<GoRoute>().firstWhere(
          (r) => r.path == '/page-detail',
    );
    pageDetailRoute = route;
  });

  group('Unit Tests — /page-detail route builder logic', () {
    test('route exists in goRoutes', () {
      expect(
        goRoutes.whereType<GoRoute>().any((r) => r.path == '/page-detail'),
        isTrue,
        reason: '/page-detail route should be registered in goRoutes',
      );
    });

    test('route path is /page-detail', () {
      expect(pageDetailRoute.path, equals('/page-detail'));
    });
  });

  group('Integration Tests — /page-detail with full router', () {
    testWidgets(
      'push to /page-detail with null extra does not crash and pops back',
      (WidgetTester tester) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: ElevatedButton(
                  key: const Key('nav_button'),
                  onPressed: () => context.push('/page-detail'),
                  child: const Text('Go'),
                ),
              ),
            ),
            pageDetailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        expect(find.text('Go'), findsOneWidget);

        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        // The route should have shown SizedBox.shrink, then the deferred
        // pop should bring us back to the home page
        expect(find.text('Go'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'push to /page-detail with valid extra renders without crashing',
      (WidgetTester tester) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: ElevatedButton(
                  key: const Key('nav_button'),
                  onPressed: () => context.push(
                    '/page-detail',
                    extra: <String, dynamic>{
                      'serviceId': '123',
                      'title': 'Test Service',
                      'description': 'Test Description',
                    },
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
            pageDetailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        expect(find.text('Go'), findsNothing); // Home should be hidden
        expect(tester.takeException(), isNull);
      },
    );
  });
}
