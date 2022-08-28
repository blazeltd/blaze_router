import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_to_regexp/path_to_regexp.dart';

abstract class IBlazeRoutes<T> {
  IBlazeRoute<T>? find(
    String path, [
    Map<String, String>? pathArgs,
  ]);

  List<IBlazeRoute<T>> get _routes;

  IBlazeRoute<T>? parentFor(IBlazeRoute<T> route);

  Iterable<E> map<E>(E Function(IBlazeRoute<T> route) f);

  @override
  String toString() => 'routes: $_routes';
}

class BlazeRoutes<T> extends IBlazeRoutes<T> {
  BlazeRoutes({
    required List<IBlazeRoute<T>> routes,
  }) {
    _routes = _recursiveCompute(routes, isFirst: true);
  }

  @override
  late final List<IBlazeRoute<T>> _routes;

  static List<IBlazeRoute<T>> _recursiveCompute<T>(
    List<IBlazeRoute<T>> routes, {
    IBlazeRoute<T>? parent,
    String? parentsPath,
    bool isFirst = false,
  }) {
    final result = <IBlazeRoute<T>>[];
    for (final route in routes) {
      if (route.children.isNotEmpty) {
        result
          ..add(route)
          ..addAll(
            _recursiveCompute<T>(
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
        '$pathBeforeBasename/${route.path}',
      );
      _fullPaths[fullPath] = route;
    }
    if (isFirst) {
      l('Recursively computed paths: $_fullPaths');
      l('Recursively computed routes: $result');
    }
    return result;
  }

  /// A map where key is a route and value is a parent route
  static final _parents = <IBlazeRoute<dynamic>, IBlazeRoute<dynamic>>{};

  /// A map where key is a fullpath for the route and value is a route
  static final _fullPaths = <String, IBlazeRoute<dynamic>>{};

  @override
  IBlazeRoute<T>? parentFor(IBlazeRoute<T> route) =>
      _parents[route] as IBlazeRoute<T>?;

  @override
  IBlazeRoute<T>? find(
    String path, [
    Map<String, String>? pathArgs,
  ]) {
    final nPath = p.normalize('/$path');

    for (final pathRoute in _fullPaths.entries) {
      l('Searching for route with path: $path, route: ${pathRoute.key}');
      if (pathRoute.value.path == nPath) {
        return pathRoute.value as IBlazeRoute<T>;
      }
      final params = <String>[];
      final regex = pathToRegExp(pathRoute.key, parameters: params);
      final match = regex.matchAsPrefix(nPath);
      if (match != null) {
        pathArgs?.addAll(extract(params, match));
        return pathRoute.value as IBlazeRoute<T>;
      }
    }
    return null;
  }

  @override
  String toString() => 'routes: $_routes, parents: $_parents';

  @override
  Iterable<E> map<E>(E Function(IBlazeRoute<T> route) f) => _routes.map(f);
}
