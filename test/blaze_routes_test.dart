import 'package:blaze_router/blaze_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Blaze Routes Tests',
    () {
      late BlazeRoutes blazeRoutes;
      late List<IBlazeRoute> routes;
      late BlazeRoute rootRoute;
      late BlazeRoute routeWithChildren;
      late BlazeRoute childRoute;
      late BlazeRoute childRoute2;
      late BlazeRoute route;
      late Map<IBlazeRoute, IBlazeRoute> parents;

      setUpAll(() {
        rootRoute = const BlazeRoute(
          path: '/',
        );
        childRoute = const BlazeRoute(path: '/child');
        childRoute2 = const BlazeRoute(path: '/child2');
        routeWithChildren = BlazeRoute(
          path: '/home',
          children: [
            childRoute,
            childRoute2,
          ],
        );
        route = const BlazeRoute(path: '/feed');
        routes = <IBlazeRoute>[
          rootRoute,
          routeWithChildren,
          route,
        ];
        blazeRoutes = BlazeRoutes(routes: routes);
        parents = <IBlazeRoute, IBlazeRoute>{
          childRoute: routeWithChildren,
          childRoute2: routeWithChildren,
        };
      });
      group('find logic', () {
        /* Root route logic */
        test(
          'finds root route',
          () {
            final routes = BlazeRoutes(
              routes: [
                BlazeRoute(
                  path: '/',
                  buildPage: (configuration) => const MaterialPage<Object>(
                    child: Text('root'),
                  ),
                ),
              ],
            );
            final route = routes.find('/');
            expect(route, isNotNull);
            expect(route?.path, '/');
          },
        );
        test(
          'finds root route with empty path',
          () {
            final routes = BlazeRoutes(
              routes: [
                BlazeRoute(
                  path: '',
                  buildPage: (configuration) => const MaterialPage<Object>(
                    child: Text('root'),
                  ),
                ),
              ],
            );
            final route = routes.find('');
            expect(route, isNotNull);
            expect(route?.path, '');
          },
        );
        test(
          'finds root route with empty path and trailing slash',
          () {
            final routes = BlazeRoutes(
              routes: [
                BlazeRoute(
                  path: '/',
                  buildPage: (configuration) => const MaterialPage<Object>(
                    child: Text('root'),
                  ),
                ),
              ],
            );
            final route = routes.find('/');
            expect(route, isNotNull);
            expect(route?.path, '/');
          },
        );
        test(
          'finds root route with empty path and trailing slash',
          () {
            final routes = BlazeRoutes(
              routes: [
                BlazeRoute(
                  path: '',
                  buildPage: (configuration) => const MaterialPage<Object>(
                    child: Text('root'),
                  ),
                ),
              ],
            );
            final route = routes.find('');
            expect(route, isNotNull);
            expect(route?.path, '');
          },
        );
        test(
          'finds root route with empty path and trailing slash',
          () {
            final routes = BlazeRoutes(
              routes: [
                BlazeRoute(
                  path: '',
                  buildPage: (configuration) => const MaterialPage<Object>(
                    child: Text('root'),
                  ),
                ),
              ],
            );
            final route = routes.find('/');
            expect(route, isNotNull);
            expect(route?.path, '');
          },
        );
        /* Root route finding logic end */

        /* general route finding logic */
        test('Test if it finds a correct item by path', () {
          expect(blazeRoutes.find('/home'), routeWithChildren);
          expect(blazeRoutes.find('/'), rootRoute);
          expect(blazeRoutes.find('/feed'), route);
        });

        test('Test if it doesn`t find a child without parents path', () {
          expect(
            blazeRoutes.find('/child'),
            isNull,
          );
        });

        /* general route finding logic end*/
      });
      group('parents logic', () {
        test('test if parents are correct', () {
          expect(blazeRoutes.parents, parents);
        });
        test('It finds right parent for the child', () {
          expect(
            blazeRoutes.parentFor(childRoute),
            routeWithChildren,
          );
        });
        test("It doesn't find parent`s route", () {
          expect(
            blazeRoutes.parentFor(route),
            isNull,
          );
        });
        test('It finds right parent for the root', () {
          expect(
            blazeRoutes.parentFor(rootRoute),
            isNull,
          );
        });
      });
      group('innering logic', () {
        test('It throws error if innering is set', () {
          expect(
            () => BlazeRoutes(routes: routes, maxInnering: 1),
            throwsA(isA<BlazeInneringError>()),
          );
        });
        test('It returns normally if innering is not set', () {
          expect(
            () => BlazeRoutes(routes: routes),
            returnsNormally,
          );
        });
        test('It works OK if innering is higher than cur. route innering', () {
          expect(
            () => BlazeRoutes(routes: routes, maxInnering: 10),
            returnsNormally,
          );
        });
      });
    },
  );
}
