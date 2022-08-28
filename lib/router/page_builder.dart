import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/material.dart';

typedef BlazePageBuilder<T> = Widget Function(
  BuildContext context,
  List<Page<T>> pages,
);

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

  final IBlazeRoutes<T> routes;

  final BlazePageBuilder<T> builder;

  final IBlazeConfiguration<T> configuration;

  @override
  Widget build(BuildContext context) => builder(
        context,
        computeToPages(configuration: configuration, routes: routes),
      );
}

List<Page<T>> computeToPages<T>({
  required final IBlazeConfiguration<T> configuration,
  required final IBlazeRoutes<T> routes,
}) {
  final pages = <Page<T>>[];
  for (final route in configuration.mathedRoutes) {
    final page = route.buildPage(configuration);
    pages.add(page);
  }
  final route = routes.find('/') ?? routes.find('');
  final page = route?.buildPage(configuration);
  if (page != null) {
    pages.insert(0, page);
  } else {
    l('Did not find root page');
  }
  l('computed pages: $pages');

  return pages;
}
