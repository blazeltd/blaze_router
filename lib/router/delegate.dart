
import 'package:blaze_router/router/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef BlazeBuild<T> = List<Page<T>> Function(
  BuildContext context,
  Uri? configuration,
);

class BlazeDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  BlazeDelegate({required this.buildPages});

  final BlazeBuild buildPages;

  Uri? _configuration;

  final _globalKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final pages = buildPages(context, _configuration);

    return Navigator(
      reportsRouteUpdateToEngine: true,
      restorationScopeId: 'blaze-router-restoration-scope',
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        l('Pop Navigator');
        navigatorKey?.currentState?.pop();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    l('SetNewRoutePath $configuration');
    _configuration = configuration;
    notifyListeners();

    return SynchronousFuture(null);
  }

  @override
  Uri? get currentConfiguration => _configuration;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _globalKey;
}
