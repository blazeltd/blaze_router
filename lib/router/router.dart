import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/widget/inherited_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

abstract class IBlazeRouter {
  /// router delegate
  IBlazeDelegate get delegate;

  /// route information parser
  IBlazeParser get parser;

  /// recursively computed routes with helpful getters
  /// used inside of the router lib.
  IBlazeRoutes get routes;

  /// get state from the configuration nearby
  Map<String, dynamic> get state;

  /// get path params from the configuration nearby
  Map<String, String> get pathParams;

  /// get query params from the configuration nearby
  Map<String, String> get queryParams;

  /// get current location
  String get location;

  /// get current configuration
  IBlazeConfiguration? get configuration;

  Future<void> push(
    String path, {
    Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String> queryParams = const {},
  });

  Future<void> pop();
}

class BlazeRouter extends IBlazeRouter {
  BlazeRouter({
    required List<IBlazeRoute> routes,
    int? maxInnering,
  }) : routes = BlazeRoutes(
          routes: routes,
          maxInnering: maxInnering,
        ) {
    parser = BlazeParser(routes: this.routes);
    delegate = BlazeDelegate(router: this);
  }

  @override
  late final IBlazeRoutes routes;

  @override
  late final IBlazeDelegate delegate;

  @override
  late final IBlazeParser parser;

  @override
  Map<String, dynamic> get state =>
      delegate.currentConfiguration?.state ?? const <String, dynamic>{};

  @override
  Map<String, String> get pathParams =>
      delegate.currentConfiguration?.pathParams ?? const <String, String>{};

  @override
  Map<String, String> get queryParams =>
      delegate.currentConfiguration?.queryParams ?? const <String, String>{};

  @override
  String get location => delegate.currentConfiguration?.location ?? '/';

  @override
  IBlazeConfiguration? get configuration => delegate.currentConfiguration;

  @override
  Future<void> push(
    String path, {
    Map<String, dynamic> state = const <String, dynamic>{},
    Map<String, String>? queryParams,
  }) async {
    final newConfiguration = await parser.parseRouteInformation(
      RouteInformation(
        location: path,
        state: state,
      ),
    );
    await delegate.setNewRoutePath(
      newConfiguration.withQueryParams(queryParams),
    );
  }

  @override
  Future<void> pop() async {
    // soft unwrap
    final conf = configuration;
    if (conf == null || conf.location.isEmptyRoute) {
      return SynchronousFuture(null);
    }
    final newLoc = conf.location.split('/')
      ..removeLast()
      ..removeWhere(
        (element) => element.isEmpty,
      );
    if (newLoc.isEmpty) {
      newLoc.insert(0, '/');
    }
    final newConfiguration = await parser.parseRouteInformation(
      RouteInformation(
        location: p.normalize('/' + p.joinAll(newLoc)),
        state: conf.state,
      ),
    );
    await delegate.setNewRoutePath(newConfiguration);
  }

  static IBlazeRouter of(BuildContext context, {bool listen = true}) {
    InheritedBlazeRouter? inheritedRouter;
    if (listen) {
      inheritedRouter =
          context.dependOnInheritedWidgetOfExactType<InheritedBlazeRouter>();
    } else {
      inheritedRouter = context
          .getElementForInheritedWidgetOfExactType<InheritedBlazeRouter>()
          ?.widget as InheritedBlazeRouter?;
    }
    return inheritedRouter?.router ?? _throw();
  }

  static Never _throw() {
    throw FlutterError(
      'BlazeRouter operation requested with a context that does not include a '
      'BlazeRouter.',
    );
  }
}
