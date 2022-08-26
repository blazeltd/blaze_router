import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/page_builder.dart';
import 'package:blaze_router/router/route.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef BlazeBuild<T> = List<Page<T>> Function(
  BuildContext context,
  Uri? configuration,
);

abstract class IBlazeDelegate<T> extends RouterDelegate<IBlazeConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {}

class BlazeDelegate<T> extends IBlazeDelegate<T> {
  BlazeDelegate({required List<IBlazeRoute<T>> routes}) {
    _routes = BlazeRoutes(routes: routes);
  }

  late final BlazeRoutes<T> _routes;

  IBlazeConfiguration? _configuration;

  @override
  Widget build(BuildContext context) => PageBuilder(
        configuration: currentConfiguration!,
        routes: _routes,
        builder: (context, pages) {
          l('build pages: $pages');
          return Navigator(
            pages: pages,
            restorationScopeId: 'blaze-router-restoration-scope',
            reportsRouteUpdateToEngine: true,
            key: navigatorKey,
            onPopPage: (route, dynamic result) {
              if (!route.didPop(result)) {
                return false;
              }
              return true;
            },
          );
        },
      );

  @override
  Future<void> setNewRoutePath(IBlazeConfiguration configuration) {
    l('SetNewRoutePath $configuration');

    if (_configuration == configuration) {
      return SynchronousFuture(null);
    }

    _configuration = configuration;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  IBlazeConfiguration? get currentConfiguration => _configuration;

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      GlobalObjectKey<NavigatorState>(this);
}
