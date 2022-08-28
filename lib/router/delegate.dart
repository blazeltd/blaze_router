import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/page_builder.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef BlazeBuild<T> = List<Page<T>> Function(
  BuildContext context,
  Uri? configuration,
);

abstract class IBlazeDelegate<T> extends RouterDelegate<IBlazeConfiguration<T>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {}

class BlazeDelegate<T> extends IBlazeDelegate<T> {
  BlazeDelegate({required this.routes});
  final IBlazeRoutes<T> routes;

  IBlazeConfiguration<T>? _configuration;

  @override
  Widget build(BuildContext context) => PageBuilder<T>(
        configuration: currentConfiguration!,
        routes: routes,
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
  Future<void> setNewRoutePath(IBlazeConfiguration<T> configuration) {
    l('SetNewRoutePath $configuration');

    if (_configuration == configuration) {
      return SynchronousFuture(null);
    }

    _configuration = configuration;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  IBlazeConfiguration<T>? get currentConfiguration => _configuration;

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      GlobalObjectKey<NavigatorState>(this);
}
