import 'package:blaze_router/blaze_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Blaze Router Tests', () {
    final rootRoute = BlazeRoute(
      path: '/',
      buildPage: (configuration, _) => MaterialPage(
        child: Builder(
          builder: (context) => Text(
            BlazeRouter.of(context).location,
          ),
        ),
      ),
    );
    final homeRoute = BlazeRoute(
      path: '/home',
      buildPage: (configuration, _) => MaterialPage(
        child: Material(
          child: Builder(
            builder: (context) => Column(
              children: [
                Text(
                  BlazeRouter.of(context, listen: false).location,
                ),
                BackButton(onPressed: Navigator.of(context).pop),
              ],
            ),
          ),
        ),
      ),
    );
    const userRoute3 = BlazeRoute(path: '/:age');
    const userRoute2 = BlazeRoute(
      path: '/:name',
      children: [
        userRoute3,
      ],
    );
    const userRoute = BlazeRoute(
      path: '/user/:id',
      children: [
        userRoute2,
      ],
    );
    final routes = [
      rootRoute,
      homeRoute,
      userRoute,
      userRoute2,
      userRoute3,
    ];
    test('check if routes are right', () {
      final router = BlazeRouter(routes: routes);
      expect(
        router.routes,
        BlazeRoutes(routes: routes),
      );
    });

    test('check if delegate is right', () {
      final router = BlazeRouter(routes: routes);

      expect(
        router.delegate,
        isInstanceOf<RouterDelegate<Object>>(),
      );
    });

    test('check if information parser is right', () {
      final router = BlazeRouter(routes: routes);

      expect(
        router.parser,
        isInstanceOf<RouteInformationParser<Object>>(),
      );
    });

    test('state with empty configuration', () {
      final router = BlazeRouter(routes: routes);

      expect(router.state, const <String, dynamic>{});
    });

    test('path params with empty configuration', () {
      final router = BlazeRouter(routes: routes);

      expect(router.pathParams, const <String, String>{});
    });

    test('query params with empty configuration', () {
      final router = BlazeRouter(routes: routes);

      expect(router.queryParams, const <String, String>{});
    });

    test('configuration test without any actions', () {
      final router = BlazeRouter(routes: routes);

      expect(router.configuration, null);
    });

    test('test push', () {
      final router = BlazeRouter(routes: routes);

      router.push('/home').whenComplete(() => expect(router.location, '/home'));
    });

    test('test pop with empty path', () {
      final router = BlazeRouter(routes: routes);
      expect(router.location, '/');
      router.pop().whenComplete(
            () => expect(router.location, '/'),
          );
    });
    test('test pop after successfull push', () {
      final router = BlazeRouter(routes: routes);
      expect(router.location, '/');
      router.push('/home').whenComplete(
        () {
          expect(router.location, '/home');
          return router.pop().whenComplete(
            () {
              expect(router.location, '/');
            },
          );
        },
      );
    });

    testWidgets('test Navigator.of(context).pop() method', (tester) async {
      final router = BlazeRouter(routes: routes);
      expect(router.location, '/');
      await tester.pumpWidget(
        MaterialApp.router(
          routeInformationParser: router.parser,
          routerDelegate: router.delegate,
        ),
      );
      await router.push('/home');
      await tester.pumpAndSettle();
      expect(router.location, '/home');
      await tester.tap(find.byType(BackButton));
      expect(router.location, '/');
    });

    testWidgets('test empty build page error', (tester) async {
      final router = BlazeRouter(
        routes: const [BlazeRoute(path: '/')],
      );
      await tester.pumpWidget(
        MaterialApp.router(
          routeInformationParser: router.parser,
          routerDelegate: router.delegate,
        ),
      );
      expect(
        tester.takeException(),
        isA<EmptyPagesException>(),
      );
    });

    testWidgets('test `of` method', (tester) async {
      final router = BlazeRouter(routes: routes);
      await tester.pumpWidget(
        BlazeRouterTestApp(
          router: router,
        ),
      );
      // route without listening, just getting blaze router
      await router.push('/home').then((value) => tester.pump());
    });

    testWidgets(
      'test if it throws an exception where blaze '
      'router in context was not found',
      (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) => Text(BlazeRouter.of(context).location),
          ),
        );
        final dynamic exception = tester.takeException();
        expect(exception, isInstanceOf<FlutterError>());
      },
    );
  });
}

/// {@template blaze_router_test}
/// BlazeRouterTestApp widget
/// {@endtemplate}
class BlazeRouterTestApp extends StatelessWidget {
  /// {@macro blaze_router_test}
  const BlazeRouterTestApp({
    required this.router,
    super.key,
  });

  final IBlazeRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: router.parser,
        routerDelegate: router.delegate,
      );
} // BlazeRouterTestApp
