import 'dart:collection';

import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:path/path.dart' as p;

abstract class IBlazeMatcher {
  IBlazeRoutes get routes;

  List<IBlazeRoute> call({
    required final String location,
    final Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String>? pathArgs,
  });
}

class BlazeMatcher extends IBlazeMatcher {
  BlazeMatcher({
    required this.routes,
  });

  @override
  final IBlazeRoutes routes;

  @override
  List<IBlazeRoute> call({
    required final String location,
    final Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String>? pathArgs,
  }) {
    final routesFromConf = <IBlazeRoute>[];

    final segments = Uri.parse(location).path.pathSegments;
    
    final lList = LinkedList<_LinkedItem>()
      ..addAll(segments.map(_LinkedItem.new));

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
  IBlazeRoute? _recursiveMatch({
    required _LinkedItem segment,
    required IBlazeRoutes routes,
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
