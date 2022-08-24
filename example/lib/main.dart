import 'dart:async';
import 'dart:developer' as developer;

import 'package:blaze_router/blaze_router.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
        runApp(const App());
      },
      (error, stackTrace) => developer.log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
    );

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      routerDelegate: BlazeDelegate(
        buildPages: (context, configuration) => [
          if (configuration.toString() == '/')
            const MaterialPage(
              child: Main(),
            ),
          if (configuration.toString() == '/second')
            const MaterialPage(
              child: Second(),
            )
        ],
      ),
      routeInformationParser: BlazeParser(),
    );
  }
} // App

/// {@template main}
/// Main widget
/// {@endtemplate}
class Main extends StatelessWidget {
  /// {@macro main}
  const Main({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
} // Main

/// {@template main}
/// Second widget
/// {@endtemplate}
class Second extends StatelessWidget {
  /// {@macro main}
  const Second({super.key});

  @override
  Widget build(BuildContext context) => const Material(
        child: Text('Second'),
      );
} // Second
