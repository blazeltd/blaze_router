import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_to_regexp/path_to_regexp.dart';

abstract class IBlazeRoutes {
  IBlazeRoute? find(
    String path, [
    Map<String, String>? pathArgs,
  ]);

  List<IBlazeRoute> get _routes;

  IBlazeRoute? parentFor(IBlazeRoute route);

  Iterable<E> map<E>(E Function(IBlazeRoute route) f);

  @override
  String toString() => 'routes: $_routes';
}

class BlazeRoutes extends IBlazeRoutes {
  BlazeRoutes({
    required List<IBlazeRoute> routes,
  }) {
    _routes = _recursiveCompute(routes, isFirst: true);
  }

  @override
  late final List<IBlazeRoute> _routes;

  static List<IBlazeRoute> _recursiveCompute(
    List<IBlazeRoute> routes, {
    IBlazeRoute? parent,
    String? parentsPath,
    bool isFirst = false,
  }) {
    final result = <IBlazeRoute>[];
    for (final route in routes) {
      if (route.children.isNotEmpty) {
        result
          ..add(route)
          ..addAll(
            _recursiveCompute(
              route.children,
              parent: route,
              parentsPath: route.path,
            ),
          );
      } else {
        if (parent != null) {
          _parents[route] = parent;
        }
        result.add(route);
      }
      final pathBeforeBasename = parentsPath ?? '';
      final fullPath = p.normalize(
        '/$pathBeforeBasename/${route.path}',
      );
      final innering = fullPath.split('/')
        ..removeWhere(
          (element) => element.isEmpty,
        );
      try {
        final map = _fullPaths[innering.length];
        _fullPaths[innering.length] = {
          ...?map,
          ...{
            fullPath: route,
          },
        };
      } on Object catch (e) {
        l('You have exceeded the innering length limit of 20 $e');
      }
    }
    if (isFirst) {
      l('Recursively computed paths: $_fullPaths');
      l('Recursively computed routes: $result');
    }
    return result;
  }

  /// A map where key is a route and value is a parent route
  static final _parents = <IBlazeRoute, IBlazeRoute>{};

  /// A map where key is a fullpath for the route and value is a route
  static final _fullPaths = <int, Map<String, IBlazeRoute>>{}..addEntries(
      List.generate(
        20,
        (index) => MapEntry(
          index,
          const <String, IBlazeRoute>{},
        ),
      ),
    );

  @override
  IBlazeRoute? parentFor(IBlazeRoute route) => _parents[route];

  @override
  IBlazeRoute? find(
    String path, [
    Map<String, String>? pathArgs,
  ]) {
    final nPath = p.normalize('/$path');
    final innering = nPath.split('/')
      ..removeWhere(
        (element) => element.isEmpty,
      );

    for (final pathRouteEntry in _fullPaths[innering.length]!.entries) {
      l('Searching for route with path: $path, route: ${pathRouteEntry.key}');
      if (pathRouteEntry.value.path == nPath) {
        return pathRouteEntry.value;
      }
      final params = <String>[];
      final regex = pathToRegExp(pathRouteEntry.key, parameters: params);
      final match = regex.matchAsPrefix(nPath);
      if (match != null) {
        pathArgs?.addAll(extract(params, match));
        return pathRouteEntry.value;
      }
    }
    return null;
  }

  @override
  String toString() => 'routes: $_routes, parents: $_parents';

  @override
  Iterable<E> map<E>(E Function(IBlazeRoute route) f) => _routes.map(f);
}
