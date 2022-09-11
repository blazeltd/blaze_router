import 'dart:async';

import 'package:blaze_router/router/router.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded<Future<void>>(
      () async => runApp(
        const App(),
      ),
      (error, stackTrace) => Zone.root.print(
        'Top level exception $error $stackTrace',
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
  late final BlazeRouter router;

  @override
  void initState() {
    super.initState();
    router = BlazeRouter(routes: routes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      routerDelegate: router.delegate,
      routeInformationParser: router.parser,
      restorationScopeId: 'root-restoration-scope',
    );
  }
}
