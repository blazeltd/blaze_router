import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef BlazePage<T> = Page<T> Function(
  IBlazeConfiguration configuration,
);

@immutable
abstract class IBlazeRoute {
  const IBlazeRoute();

  /// the route`s path
  String get path;

  /// the route`s page
  BlazePage<Object>? get buildPage;

  /// inner routes
  List<IBlazeRoute> get children;

  @override
  String toString() => 'IBlazeRoute('
      'path: $path, '
      'children: $children, '
      ')';

  @override
  int get hashCode => Object.hash(path, buildPage, children);

  @override
  bool operator ==(Object other) =>
      other is IBlazeRoute &&
      const DeepCollectionEquality().equals(path, other.path) &&
      const DeepCollectionEquality().equals(buildPage, other.buildPage) &&
      const DeepCollectionEquality().equals(children, other.children);
}

class BlazeRoute extends IBlazeRoute {
  const BlazeRoute({
    required this.path,
    this.buildPage,
    this.children = const [],
  });

  @override
  final String path;

  @override
  final List<IBlazeRoute> children;

  @override
  final BlazePage<Object>? buildPage;
}
