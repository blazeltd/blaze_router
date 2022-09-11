import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
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

  List<Page<Object>> computeToPages({
    required final IBlazeConfiguration configuration,
    required final IBlazeRoutes routes,
  }) {
    final pages = <Page<Object>>[
      ...recursiveCompute(
        configuration: configuration,
        routes: routes,
      )
    ];

    l('computed pages: $pages');

    if (pages.isEmpty) {
      throw EmptyPagesException();
    }

    return pages.removeDuplicates();
  }

  /// Recursively compute pages
  /// from [routes] and [configuration]
  /// to [List<Page>]
  ///
  /// **Examples**:
  ///
  /// ```dart
  /// routes: [
  ///   BlazeNestedRoute(
  ///     path: '/home',
  ///     buildPage: (c, pages) => buildPage(pages),
  ///     children: [
  ///       BlazeRoute(
  ///         path: '/profile',
  ///         buildPage: bla-bla-bla,
  ///       ),
  ///       BlazeRoute(
  ///         path: '/another',
  ///         buildPage: bla-bla-bla,
  ///       ),
  ///     ],
  ///   ),
  /// ];
  /// ```
  /// Then, for path `/home/profile` it will get such routes:
  ///
  /// ```dart
  /// routes: [
  ///   BlazeNestedRoute(
  ///     path: '/home',
  ///     buildPage: (c, pages) => buildPage(pages),
  ///     children: [
  ///       BlazeRoute(
  ///         path: '/profile',
  ///         buildPage: bla-bla-bla,
  ///       ),
  ///       BlazeRoute(
  ///         path: '/another',
  ///         buildPage: bla-bla-bla,
  ///       ),
  ///     ],
  ///   ),
  ///   BlazeRoute(
  ///     path: '/profile',
  ///     buildPage: bla-bla-bla,
  ///   ),
  /// ];
  /// ```
  ///
  /// If path is `/home/profile/another` it will get routes as above.
  /// It means that only one route after following can be innered.
  List<Page<Object>> recursiveCompute({
    required final IBlazeConfiguration configuration,
    required final IBlazeRoutes routes,
    int i = 0,
  }) {
    final pages = <Page<Object>>[];
    final matchedRoutes = configuration.mathedRoutes;
    for (var index = i; index < matchedRoutes.length; index++) {
      final route = matchedRoutes[index];
      if (route is BlazeNestedRoute) {
        if (index + 1 < matchedRoutes.length) {
          index++;
          final nextRoute = matchedRoutes[index];
          if (route.children.contains(nextRoute)) {
            if (nextRoute is BlazeNestedRoute) {
              index++;
              final p = recursiveCompute(
                configuration: configuration,
                routes: routes,
                i: index,
              );
              var emptyPage = nextRoute.emptyPage?.call(configuration);
              emptyPage ??= _emptyMaterialPage;
              final nextPage = nextRoute.buildPage?.call(
                configuration,
                [emptyPage, ...p],
              );
              if (nextPage != null) {
                pages.add(
                  route.buildPage?.call(configuration, [nextPage]) ?? nextPage,
                );
              }
            } else {
              final nextPage = nextRoute.buildPage?.call(configuration, []);
              if (nextPage != null) {
                pages.add(
                  route.buildPage?.call(configuration, [nextPage]) ?? nextPage,
                );
              }
            }
            continue;
          }
        }
      }
      Page<Object>? defaultPage;
      if (route is BlazeNestedRoute) {
        defaultPage = route.emptyPage?.call(configuration);
      }
      defaultPage ??= _emptyMaterialPage;
      final page = route.buildPage?.call(configuration, [defaultPage]);
      if (page != null) {
        pages.add(page);
      }
    }
    return pages;
  }
}

const _emptyMaterialPage = MaterialPage<Object>(child: SizedBox.shrink());
