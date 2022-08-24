
import 'package:blaze_router/router/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BlazeParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) {
    l('ParseRouteInformation loc: ${routeInformation.location}, state: ${routeInformation.state}');
    return SynchronousFuture(Uri.parse(routeInformation.location ?? ''));
  }

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) {
    l('restoreRouteInformation $configuration');
    return RouteInformation(
      location: configuration.toString(),
    );
  }
}
