import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:flutter/material.dart';

typedef BlazePageBuilder = Widget Function(
  BuildContext context,
  List<Page<Object>> pages,
);

/// {@template page_builder}
/// PageBuilder widget
/// {@endtemplate}
class PageBuilder extends StatelessWidget {
  /// {@macro page_builder}
  const PageBuilder({
    required this.routes,
    required this.builder,
    required this.configuration,
    super.key,
  });

  final IBlazeRoutes routes;

  final BlazePageBuilder builder;

  final IBlazeConfiguration configuration;

  @override
  Widget build(BuildContext context) => builder(
        context,
        computeToPages(
          configuration: configuration,
          routes: routes,
        ),
      );
}

List<Page<Object>> computeToPages({
  required final IBlazeConfiguration configuration,
  required final IBlazeRoutes routes,
}) {
  final pages = <Page<Object>>[];
  for (final route in configuration.mathedRoutes) {
    final page = route.buildPage?.call(configuration);
    if (page != null) {
      pages.add(page);
    }
  }
  final route = routes.find('/') ?? routes.find('');
  final page = route?.buildPage?.call(configuration);

  if (page != null) {
    pages.insert(0, page);
  } else {
    throw EmptyBuildPageError(route);
  }
  l('computed pages: $pages');

  return pages;
}
