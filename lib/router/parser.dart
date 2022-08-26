import 'package:blaze_router/misc/logger.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BlazeParser extends RouteInformationParser<IBlazeConfiguration> {
  @override
  Future<IBlazeConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    l(
      'ParseRouteInformation loc: ${routeInformation.location} '
      'state: ${routeInformation.state}',
    );
    try {
      final state = routeInformation.state as Map<String, dynamic>? ??
          const <String, dynamic>{};
      try {
        final uri = Uri.parse(routeInformation.location!);
        return SynchronousFuture(
          BlazeConfiguration(
            location: uri.toString(),
            state: state,
          ),
        );
      } on Object catch (e) {
        l('ParseRouteInformation error: $e');
        return SynchronousFuture(
          BlazeConfiguration(
            location: routeInformation.location!,
            state: state,
          ),
        );
      }
    } on Object catch (e) {
      l('Failed to get state from routeInformation: $e');
      return SynchronousFuture(
        BlazeConfiguration(
          location: routeInformation.location ?? '',
        ),
      );
    }
  }

  @override
  RouteInformation restoreRouteInformation(IBlazeConfiguration configuration) {
    l('restoreRouteInformation $configuration');
    return configuration.toRouteInformation();
  }
}
