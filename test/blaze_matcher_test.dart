import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/matcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('blaze matcher tests', () {
    final rootRoute = BlazeRoute(
      path: '/',
      buildPage: (configuration, pages) => const MaterialPage(
        child: Material(child: Text('root')),
      ),
    );
    final grandChildRoute = BlazeRoute(
      path: '/:id',
      buildPage: (configuration, pages) => MaterialPage(
        child: Material(
          child: Text(
            'grandchild ${configuration.pathParams['id'].toString()}',
          ),
        ),
      ),
    );
    final grandChildRoute2 = BlazeRoute(
      path: '/grand2',
      buildPage: (configuration, pages) => const MaterialPage(
        child: Material(
          child: Text(
            'GRAnD',
          ),
        ),
      ),
    );
    final childRoute = BlazeRoute(
      path: '/child',
      buildPage: (configuration, _) => const MaterialPage(
        child: Material(child: Text('child')),
      ),
      children: [
        grandChildRoute,
        grandChildRoute2,
      ],
    );

    final routes = BlazeRoutes(
      routes: [rootRoute, childRoute],
    );

    final matcher = BlazeMatcher(routes: routes);

    test('match location', () {
      final matchedRoutes = matcher(
        location: '/child/1',
      );
      expect(matchedRoutes.length, 3);
      expect(
        matchedRoutes,
        [rootRoute, childRoute, grandChildRoute],
      );
    });

    test('match location and extract path args', () {
      final map = <String, String>{};
      final matchedRoutes = matcher(
        location: '/child/1',
        pathArgs: map,
      );
      expect(matchedRoutes.length, 3);
      expect(
        matchedRoutes,
        [rootRoute, childRoute, grandChildRoute],
      );
      expect(map, {'id': '1'});
    });

    test('match empty location', () {
      final matchedRoutes = matcher(location: '');
      expect(matchedRoutes.length, 1);
      expect(matchedRoutes, [rootRoute]);
    });

    test('normally matches', () {
      expect(
        matcher(location: '/child'),
        [rootRoute, childRoute],
      );
    });

    test('match only one nested', () {
      expect(
        matcher(location: '/child/1/grand2'),
        [rootRoute, childRoute, grandChildRoute],
      );
    });

    test('match slash location', () {
      final matchedRoutes = matcher(location: '/');
      expect(matchedRoutes.length, 1);
      expect(matchedRoutes, [rootRoute]);
    });

    test('match wrong location', () {
      final matchedRoutes = matcher(location: 'fkafnsdjfjsf');
      expect(
        matchedRoutes,
        isEmpty,
      );
    });
  });
}
