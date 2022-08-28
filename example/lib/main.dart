import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/routes.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded<Future<void>>(
      () async => runApp(
        const App(),
      ),
      (error, stackTrace) => developer.log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
      zoneValues: {
        #debug: true,
      },
    );

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final blazeRoutes = BlazeRoutes<Object>(routes: routes);
    return MaterialApp.router(
      title: 'Material App',
      routerDelegate: BlazeDelegate(routes: blazeRoutes),
      routeInformationParser: BlazeParser<Object>(routes: blazeRoutes),
      routeInformationProvider: BlazeInformationProvider(
        initialRouteInformation: RouteInformation(
          location: PlatformDispatcher.instance.defaultRouteName,
        ),
      ),
    );
  }
}
