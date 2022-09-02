import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_to_regexp/path_to_regexp.dart';

@immutable
abstract class IBlazeRoutes {
  IBlazeRoute? find(
    String path, [
    Map<String, String>? pathArgs,
  ]);

  int? get maxInnering;

  List<IBlazeRoute> get blazeRoutes;

  IBlazeRoute? parentFor(IBlazeRoute route);

  Iterable<E> map<E>(E Function(IBlazeRoute route) f);

  @override
  int get hashCode => Object.hashAll([
        ...blazeRoutes,
        maxInnering,
      ]);

  @override
  bool operator ==(Object other) =>
      other is IBlazeRoutes &&
      const DeepCollectionEquality().equals(maxInnering, other.maxInnering) &&
      const DeepCollectionEquality().equals(blazeRoutes, other.blazeRoutes);
}

class BlazeRoutes extends IBlazeRoutes {
  BlazeRoutes({
    required List<IBlazeRoute> routes,
    this.maxInnering,
  }) {
    blazeRoutes = recursiveCompute(routes, isFirst: true);
  }

  @override
  final int? maxInnering;

  @override
  @visibleForTesting
  late final List<IBlazeRoute> blazeRoutes;

  @visibleForTesting
  List<IBlazeRoute> recursiveCompute(
    List<IBlazeRoute> routes, {
    IBlazeRoute? parent,
    String? parentsPath,
    bool isFirst = false,
  }) {
    final result = <IBlazeRoute>[];
    for (final route in routes.sortRoutes()) {
      if (route.children.isNotEmpty) {
        result
          ..add(route)
          ..addAll(
            recursiveCompute(
              route.children.sortRoutes(),
              parent: route,
              parentsPath: route.path,
            ),
          );
      } else {
        if (parent != null) {
          parents[route] = parent;
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
        if (maxInnering != null && innering.length > maxInnering!) {
          throw BlazeInneringError(
            maxInnering!,
            innering.length,
          );
        }
        final map = fullPaths[innering.length];
        fullPaths[innering.length] = {
          ...?map,
          ...{
            fullPath: route,
          },
        };
      } on Object {
        rethrow;
      }
    }
    if (isFirst) {
      l('Recursively computed paths: $fullPaths');
      l('Recursively computed routes: $result');
    }
    return result;
  }

  /// A map where key is a route and value is a parent route
  @visibleForTesting
  final parents = <IBlazeRoute, IBlazeRoute>{};

  /// A map where key is a fullpath for the route and value is a route
  @visibleForTesting
  final fullPaths = <int, Map<String, IBlazeRoute>>{};

  @override
  IBlazeRoute? parentFor(IBlazeRoute route) => parents[route];

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

    for (final pathRouteEntry in fullPaths[innering.length]!.entries) {
      l(
        'Searching for route with path: $nPath, route: ${pathRouteEntry.key}, '
        'isEqual: ${nPath == pathRouteEntry.key}',
      );
      if (pathRouteEntry.key.trim() == nPath.trim()) {
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
  String toString() => 'routes: $blazeRoutes, parents: $parents';

  @override
  Iterable<E> map<E>(E Function(IBlazeRoute route) f) => blazeRoutes.map(f);
}
