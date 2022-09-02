import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/page_builder.dart';
import 'package:blaze_router/router/router.dart';
import 'package:blaze_router/widget/inherited_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef BlazeBuild = List<Page<Object>> Function(
  BuildContext context,
  Uri? configuration,
);

abstract class IBlazeDelegate extends RouterDelegate<IBlazeConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {}

class BlazeDelegate extends IBlazeDelegate {
  BlazeDelegate({required this.router});
  final IBlazeRouter router;

  IBlazeConfiguration? _configuration;

  @override
  Widget build(BuildContext context) => PageBuilder(
        configuration: currentConfiguration!,
        routes: router.routes,
        builder: (context, pages) {
          l('build pages: $pages');
          return InheritedBlazeRouter(
            router: router,
            child: Navigator(
              pages: pages,
              restorationScopeId: 'blaze-router-restoration-scope',
              reportsRouteUpdateToEngine: true,
              key: navigatorKey,
              onPopPage: (route, dynamic result) {
                if (!route.didPop(result)) {
                  return false;
                }
                router.pop();
                return true;
              },
            ),
          );
        },
      );

  @override
  Future<void> setNewRoutePath(IBlazeConfiguration configuration) {
    l('SetNewRoutePath $configuration');
    if (_configuration != configuration) {
      _configuration = configuration;
      notifyListeners();
    }

    return SynchronousFuture(null);
  }

  @override
  IBlazeConfiguration? get currentConfiguration => _configuration;

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      GlobalObjectKey<NavigatorState>(this);
}
