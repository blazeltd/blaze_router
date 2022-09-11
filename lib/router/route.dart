import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef BlazePage = Page<Object> Function(
  IBlazeConfiguration configuration,
  List<Page<Object>>? pages,
);

typedef EmptyBlazePage = Page<Object> Function(
  IBlazeConfiguration configuration,
);

@immutable
abstract class IBlazeRoute {
  const IBlazeRoute();

  /// the route`s path
  String get path;

  /// the route`s page
  BlazePage? get buildPage;

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

/// Default blaze route
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
  final BlazePage? buildPage;
}

/// Use only if you want to nest pages
class BlazeNestedRoute extends IBlazeRoute {
  const BlazeNestedRoute({
    required this.path,
    this.buildPage,
    this.emptyPage,
    this.children = const [],
  });

  @override
  final String path;

  @override
  final List<IBlazeRoute> children;

  @override
  final BlazePage? buildPage;

  final EmptyBlazePage? emptyPage;
}
