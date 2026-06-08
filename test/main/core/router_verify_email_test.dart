import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Extracts the `/verify-email` route builder from goRoutes for isolated testing.
///
/// We import the route list and test the builder function directly to verify
/// null-safety guard clauses work correctly without requiring the full
/// Riverpod/Firebase/Isar stack.
import 'package:majadigi_mobile_rebuild/main/core/router.dart' show goRoutes;

void main() {
  // Find the /verify-email GoRoute from the route list
  late GoRoute verifyEmailRoute;

  setUpAll(() {
    final route = goRoutes.whereType<GoRoute>().firstWhere(
          (r) => r.path == '/verify-email',
    );
    verifyEmailRoute = route;
  });

  // -------------------------------------------------------------------------
  // UNIT TESTS — Route registration
  // -------------------------------------------------------------------------
  group('Unit Tests — /verify-email route builder logic', () {
    test('route exists in goRoutes', () {
      expect(
        goRoutes.whereType<GoRoute>().any((r) => r.path == '/verify-email'),
        isTrue,
        reason: '/verify-email route should be registered in goRoutes',
      );
    });

    test('route path is /verify-email', () {
      expect(verifyEmailRoute.path, equals('/verify-email'));
    });
  });

  // -------------------------------------------------------------------------
  // WIDGET TESTS — Null safety of the route builder
  // -------------------------------------------------------------------------
  group('Widget Tests — /verify-email navigation safety', () {
    /// Helper: builds a GoRouter with a home route and the verify-email route,
    /// then navigates to /verify-email with the provided [extra].
    ///
    /// The home route acts as a navigation stack base so that `context.pop()`
    /// from the deferred callback has something to pop to.
    GoRouter _buildTestRouter({Object? extra}) {
      return GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Text('Home')),
          ),
          verifyEmailRoute,
        ],
      );
    }

    testWidgets(
      'renders SizedBox.shrink when state.extra is null (no crash)',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Navigate to /verify-email with NO extra
        router.push('/verify-email');
        await tester.pumpAndSettle();

        // The builder should return SizedBox.shrink and schedule a pop,
        // so after pump the user should be back on home.
        // The key assertion is: no unhandled TypeError crash.
        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'renders SizedBox.shrink when email key is missing from extras',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        router.push('/verify-email', extra: <String, String>{'name': 'test'});
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'renders SizedBox.shrink when email is empty string',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        router.push('/verify-email', extra: <String, String>{'email': ''});
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'handles wrong extra type gracefully (not a Map)',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Pass a String instead of Map — the `is!` check should catch this
        router.push('/verify-email', extra: 'not_a_map');
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'renders RegisterVerificationScreen when valid email is provided',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        router.push(
          '/verify-email',
          extra: <String, String>{'email': 'user@example.com'},
        );
        await tester.pumpAndSettle();

        // The verification screen shows this title text
        expect(find.text('Verifikasi Terkirim!'), findsOneWidget);
      },
    );

    testWidgets(
      'renders resend button when valid email is provided',
      (WidgetTester tester) async {
        final router = _buildTestRouter();
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        router.push(
          '/verify-email',
          extra: <String, String>{'email': 'hello@majadigi.test'},
        );
        await tester.pumpAndSettle();

        // The "Kirim Kembali" (resend) button should be present
        expect(find.text('Kirim Kembali'), findsOneWidget);
      },
    );
  });

  // -------------------------------------------------------------------------
  // INTEGRATION TESTS — Real navigation with context.push()
  // -------------------------------------------------------------------------
  group('Integration Tests — /verify-email with full router', () {
    testWidgets(
      'push to /verify-email with null extra does not crash and pops back',
      (WidgetTester tester) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: ElevatedButton(
                  key: const Key('nav_button'),
                  onPressed: () => context.push('/verify-email'),
                  child: const Text('Go'),
                ),
              ),
            ),
            verifyEmailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Verify we start on Home
        expect(find.text('Go'), findsOneWidget);

        // Tap to navigate — no extra data provided
        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        // The route should have shown SizedBox.shrink, then the deferred
        // pop should bring us back to the home page
        expect(find.text('Go'), findsOneWidget);
        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'push to /verify-email with valid extra renders the screen',
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
                    '/verify-email',
                    extra: <String, String>{'email': 'test@majadigi.com'},
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
            verifyEmailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // Navigate with valid email
        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        expect(find.text('Verifikasi Terkirim!'), findsOneWidget);
        expect(find.text('Go'), findsNothing); // Home should be hidden
      },
    );

    testWidgets(
      'push to /verify-email with empty email pops back to home',
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
                    '/verify-email',
                    extra: <String, String>{'email': ''},
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
            verifyEmailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        // Should pop back to home
        expect(find.text('Go'), findsOneWidget);
        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );

    testWidgets(
      'push to /verify-email with wrong type extra pops back to home',
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
                    '/verify-email',
                    extra: 42, // Wrong type: int instead of Map
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
            verifyEmailRoute,
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('nav_button')));
        await tester.pumpAndSettle();

        // Should gracefully pop back to home, not crash with TypeError
        expect(find.text('Go'), findsOneWidget);
        expect(find.text('Verifikasi Terkirim!'), findsNothing);
      },
    );
  });
}
