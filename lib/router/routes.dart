import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';

abstract class IBlazeRoutes<T> {
  IBlazeRoute<T>? operator [](String path);

  List<IBlazeRoute<T>> get _routes;

  @override
  String toString() => 'routes: $_routes';
}

class BlazeRoutes<T> extends IBlazeRoutes<T> {
  BlazeRoutes({
    required List<IBlazeRoute<T>> routes,
  }) {
    _routes = _recursiveCompute(routes);
    l('Recursively computed routes: ${toString()}');
  }

  @override
  late final List<IBlazeRoute<T>> _routes;

  static List<IBlazeRoute<T>> _recursiveCompute<T>(
    List<IBlazeRoute<T>> routes, {
    IBlazeRoute<T>? parent,
  }) {
    final result = <IBlazeRoute<T>>[];
    for (final route in routes) {
      if (route.children.isNotEmpty) {
        result.addAll(
          _recursiveCompute<T>(
            route.children,
            parent: route,
          ),
        );
      } else {
        if (parent != null) {
          parents[route] = parent;
        }
        result.add(route);
      }
    }
    return result;
  }

  /// A map where key is a route and value is a parent route
  static final parents = <IBlazeRoute<dynamic>, IBlazeRoute<dynamic>>{};

  @override
  IBlazeRoute<T>? operator [](String path) {
    for (final route in _routes) {
      if (route.path == path) {
        return route;
      }
    }
    return null;
  }

  @override
  String toString() => 'routes: $_routes, parents: $parents';
}
