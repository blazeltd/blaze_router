import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:flutter/material.dart';

typedef BlazePage<T> = Page<T> Function(IBlazeConfiguration configuration);

abstract class IBlazeRoute<T> {
  /// the route`s path
  String get path;

  /// the route`s page
  BlazePage<T> get buildPage;

  /// inner routes
  List<IBlazeRoute<T>> get children;

  @override
  String toString() => 'IBlazeRoute('
      'path: $path, '
      'children: $children, '
      ')';
}

class BlazeRoute<T> extends IBlazeRoute<T> {
  BlazeRoute({
    required this.path,
    required this.buildPage,
    this.children = const [],
  });

  @override
  final String path;

  @override
  final List<IBlazeRoute<T>> children;

  @override
  final BlazePage<T> buildPage;
}