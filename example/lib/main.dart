import 'dart:async';
import 'dart:developer' as developer;

import 'package:blaze_router/router/router.dart';
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
    final router = BlazeRouter(routes: routes);
    return MaterialApp.router(
      title: 'Material App',
      routerDelegate: router.delegate,
      routeInformationParser: router.parser,
      routeInformationProvider: router.provider,
    );
  }
}
