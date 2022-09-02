import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/matcher.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class IBlazeParser
    extends RouteInformationParser<IBlazeConfiguration> {}

class BlazeParser extends IBlazeParser {
  BlazeParser({
    required this.routes,
  }) : _matcher = BlazeMatcher(routes: routes);

  final IBlazeRoutes routes;
  final IBlazeMatcher _matcher;

  @override
  Future<IBlazeConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    l(
      'ParseRouteInformation loc: ${routeInformation.location} '
      'state: ${routeInformation.state}',
    );
    final state = routeInformation.state as Map<String, dynamic>? ??
        const <String, dynamic>{};
    final pathArgs = <String, String>{};
    final uri = Uri.parse(
      routeInformation.location ?? '',
    );
    final matchedRoutes = _matcher(
      location: uri.toString(),
      state: state,
      pathArgs: pathArgs,
    );
    return SynchronousFuture(
      BlazeConfiguration(
        location: uri.toString(),
        state: state,
        mathedRoutes: matchedRoutes,
        pathParams: pathArgs,
      ),
    );
  }

  @override
  RouteInformation restoreRouteInformation(
    IBlazeConfiguration configuration,
  ) {
    l('restoreRouteInformation $configuration');
    return configuration.toRouteInformation();
  }
}
