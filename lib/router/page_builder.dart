import 'dart:collection';

import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

typedef BlazePageBuilder<T> = Widget Function(
  BuildContext context,
  List<Page<T>> pages,
);

class _PartEntry extends LinkedListEntry<_PartEntry> {
  _PartEntry(this.part);

  final String part;
}

/// {@template page_builder}
/// PageBuilder widget
/// {@endtemplate}
class PageBuilder<T> extends StatelessWidget {
  /// {@macro page_builder}
  const PageBuilder({
    required this.routes,
    required this.builder,
    required this.configuration,
    super.key,
  });

  final BlazeRoutes<T> routes;

  final BlazePageBuilder<T> builder;

  final IBlazeConfiguration configuration;

  @override
  Widget build(BuildContext context) => builder(
        context,
        computeToPages(configuration: configuration, routes: routes),
      );
} // PageBuilder

List<Page<T>> computeToPages<T>({
  required final IBlazeConfiguration configuration,
  required final BlazeRoutes<T> routes,
}) {
  final pages = <Page<T>>[];

  final uri = Uri.parse(configuration.location);

  for (final e in uri.pathSegments) {
    final route = routes[e];
    if (route == null) {
      l('No route found for $e');
      continue;
    }
    final page = route.buildPage(configuration);
    pages.add(page);
  }
  final route = routes['/'] ?? routes[''];
  final page = route?.buildPage(configuration);
  if (page != null) {
    pages.insert(0, page);
  } else {
    l('Did not find root page');
  }
  l('computed pages: $pages');

  return pages;
}
