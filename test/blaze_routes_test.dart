import 'package:blaze_router/blaze_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Blaze Routes Tests',
    () {
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
          const homeRoute = BlazeRoute(
            path: '/home',
          );
          const rootRoute = BlazeRoute(
            path: '/',
          );
          const feedRoute = BlazeRoute(
            path: '/feed',
          );
          final routes = BlazeRoutes(
            routes: const [
              homeRoute,
              feedRoute,
              rootRoute,
            ],
          );
          expect(routes.find('/home'), homeRoute);
          expect(routes.find('/'), rootRoute);
          expect(routes.find('/feed'), feedRoute);
        });

        test('Test if it doesn`t find a child without parents path', () {
          const innerRoute = BlazeRoute(
            path: '/inner',
          );
          const feedRoute = BlazeRoute(
            path: '/feed',
            children: [innerRoute],
          );
          final routes = BlazeRoutes(
            routes: const [feedRoute],
          );
          expect(
            routes.find('/inner'),
            isNull,
          );
        });
        group('path args tests', () {
          const homeRoute = BlazeRoute(
            path: '/home/:id',
          );
          const someRoute = BlazeRoute(
            path: '/someroute',
          );

          const oneInneringRoute = BlazeRoute(
            path: '/:id',
          );
          const rootRoute = BlazeRoute(
            path: '/',
            children: [oneInneringRoute],
          );
          const feedRoute = BlazeRoute(
            path: '/feed',
          );
          final routes = BlazeRoutes(
            routes: const [
              homeRoute,
              feedRoute,
              rootRoute,
              someRoute,
            ],
          );

          test('find a route with path args and exclude arguments', () {
            final route = routes.find('/home/1');
            expect(
              route,
              homeRoute,
            );
          });

          test('should match exactly that route, not with path args', () {
            final route = routes.find('/someroute');
            expect(
              route,
              someRoute,
            );
          });

          test(
            'find a route with path args near the root and exclude args',
            () {
              final pathArgs = <String, String>{};
              final route = routes.find('/209', pathArgs);
              expect(
                route,
                oneInneringRoute,
              );
              expect(
                pathArgs,
                <String, String>{'id': '209'},
              );
            },
          );
        });

        /* general route finding logic end*/
      });
      group('parents logic', () {
        const rootRoute = BlazeRoute(
          path: '/',
        );
        const homeRoute = BlazeRoute(
          path: '/home',
        );
        const innerRoute = BlazeRoute(
          path: '/inner',
        );
        const feedRoute = BlazeRoute(
          path: '/feed',
          children: [
            innerRoute,
            homeRoute,
          ],
        );
        final routes = BlazeRoutes(
          routes: [
            rootRoute,
            homeRoute,
            feedRoute,
          ],
        );
        // right parents that should be found
        final parents = <IBlazeRoute, IBlazeRoute>{
          innerRoute: feedRoute,
          homeRoute: feedRoute,
        };

        test('test if parents are correct', () {
          expect(routes.parents, parents);
        });
        test('It finds right parent for the child', () {
          expect(
            feedRoute.children.map(routes.parentFor),
            List.filled(
              feedRoute.children.length,
              feedRoute,
            ),
          );
        });
        test("It doesn't find parent`s route", () {
          expect(
            routes.parentFor(rootRoute),
            isNull,
          );
        });
      });
      group('innering logic', () {
        const testRoute = BlazeRoute(
          path: '/dadas/dsdas/dasdad/sdaw',
        );
        final routes = [testRoute];
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

      group('full paths computing logic tests', () {
        test('check if innering was set correctly and path is right', () {
          const innerRoute = BlazeRoute(
            path: '/inner',
          );
          const feedRoute = BlazeRoute(
            path: '/feed',
            children: [innerRoute],
          );
          const rootRoute = BlazeRoute(
            path: '/',
            children: [feedRoute],
          );
          final routes = BlazeRoutes(
            routes: [rootRoute],
          );
          expect(
            routes.fullPaths[2]!.entries
                .firstWhere(
                  (element) => element.value == innerRoute,
                )
                .key,
            '/feed/inner',
          );
          expect(
            routes.fullPaths[1]!.entries
                .firstWhere(
                  (element) => element.value == feedRoute,
                )
                .key,
            '/feed',
          );
        });
      });

      group('other methods', () {
        const rootRoute = BlazeRoute(
          path: '/',
        );
        const homeRoute = BlazeRoute(
          path: '/home',
        );
        final routes = BlazeRoutes(
          routes: [
            rootRoute,
            homeRoute,
          ],
        );
        test('Maps routes correct', () {
          expect(
            routes.map((route) => route.path),
            routes.blazeRoutes.map((e) => e.path),
          );
        });

        test('to string returns normally', () {
          expect(
            routes.toString,
            returnsNormally,
          );
        });
      });
    },
  );
}
