import 'dart:collection';

import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:path/path.dart' as p;

abstract class IBlazeMatcher<T> {
  IBlazeRoutes<T> get routes;

  List<IBlazeRoute<T>> call({
    required final String location,
    final Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String>? pathArgs,
  });
}

class BlazeMatcher<T> extends IBlazeMatcher<T> {
  BlazeMatcher({
    required this.routes,
  });

  @override
  final IBlazeRoutes<T> routes;

  @override
  List<IBlazeRoute<T>> call({
    required final String location,
    final Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String>? pathArgs,
  }) {
    final routesFromConf = <IBlazeRoute<T>>[];

    final uri = Uri.parse(location);
    final lList = LinkedList<_LinkedItem>()
      ..addAll(uri.pathSegments.map(_LinkedItem.new));

    for (final e in lList) {
      l('Iterating over: $e');
      final route = routes.find(e.pathSegment);
      if (route == null) {
        final matchingRoute = _recursiveMatch(
          segment: e,
          routes: routes,
          pathArgs: pathArgs,
        );
        if (matchingRoute != null) {
          routesFromConf.add(matchingRoute);
        }
        continue;
      }
      routesFromConf.add(route);
    }

    return routesFromConf;
  }

  /// only internal usage
  IBlazeRoute<T>? _recursiveMatch({
    required _LinkedItem segment,
    required IBlazeRoutes<T> routes,
    String path = '',
    Map<String, String>? pathArgs,
  }) {
    final fullPath = p.join(segment.pathSegment, path);
    final route = routes.find(fullPath, pathArgs);
    if (route == null && segment.previous != null) {
      return _recursiveMatch(
        segment: segment.previous!,
        routes: routes,
        path: fullPath,
        pathArgs: pathArgs,
      );
    }
    return route;
  }
}

class _LinkedItem extends LinkedListEntry<_LinkedItem> {
  _LinkedItem(this.pathSegment);

  final String pathSegment;
}
