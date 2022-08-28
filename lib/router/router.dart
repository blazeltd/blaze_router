import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:flutter/material.dart';

abstract class IBlazeRouter<T> {
  IBlazeDelegate<T> get delegate;

  IBlazeParser<T> get parser;

  IBlazeInformationProvider get provider;

  IBlazeRoutes<T> get routes;
}

class BlazeRouter<T> extends IBlazeRouter<T> {
  BlazeRouter({
    required List<IBlazeRoute<T>> routes,
  }) : routes = BlazeRoutes(routes: routes) {
    delegate = BlazeDelegate<T>(routes: this.routes);
    parser = BlazeParser<T>(routes: this.routes);
    provider = BlazeInformationProvider(
      initialRouteInformation: const RouteInformation(
        location: '/',
      ),
    );
  }

  @override
  late final IBlazeRoutes<T> routes;

  @override
  late final IBlazeDelegate<T> delegate;

  @override
  late final IBlazeParser<T> parser;

  @override
  late final IBlazeInformationProvider provider;
}
