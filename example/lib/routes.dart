import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/page.dart';
import 'package:flutter/material.dart';

final routes = <BlazeRoute<Object>>[
  BlazeRoute<Object>(
    path: '/',
    buildPage: (_) => const MaterialPage(
      child: Main(),
    ),
  ),
  BlazeRoute(
      path: '/second',
      buildPage: (_) => const MaterialPage(
            child: Second(),
          ),
      children: [
        BlazeRoute(
          path: '/:id',
          buildPage: (c) => MaterialPage(
            child: Fourth(c.pathParams['id']),
          ),
        ),
      ]),
  BlazeRoute(
    path: '/third',
    buildPage: (configuration) {
      return BlazeDialogPage(
        builder: (context) {
          return Third(
            aboba: configuration.queryParams['aboba'],
          );
        },
      );
    },
  ),
];

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const Text('Main'),
            TextButton(
              onPressed: () {
                Router.of(context)
                    .routeInformationParser
                    ?.parseRouteInformation(
                      const RouteInformation(
                        location: '/second',
                      ),
                    )
                    .then(
                      (value) => Router.of(context)
                          .routerDelegate
                          .setNewRoutePath(value),
                    );
              },
              child: const Text('GO to second'),
            ),
          ],
        ),
      );
}

class Second extends StatelessWidget {
  const Second({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Second'),
          TextButton(
            onPressed: () {
              Router.of(context)
                  .routeInformationParser
                  ?.parseRouteInformation(
                    const RouteInformation(
                      location: '/third?aboba=popajopa',
                    ),
                  )
                  .then(
                    (value) => Router.of(context)
                        .routerDelegate
                        .setNewRoutePath(value),
                  );
            },
            child: const Text('GO to third'),
          ),
        ],
      ),
    );
  }
}

class Third extends StatelessWidget {
  const Third({this.aboba, Key? key}) : super(key: key);

  final String? aboba;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Third $aboba'),
          TextButton(
            onPressed: () {
              Router.of(context)
                  .routeInformationParser
                  ?.parseRouteInformation(
                    const RouteInformation(
                      location: '/',
                    ),
                  )
                  .then(
                    (value) => Router.of(context)
                        .routerDelegate
                        .setNewRoutePath(value),
                  );
            },
            child: const Text('GO to main'),
          ),
        ],
      ),
    );
  }
}

class Fourth extends StatelessWidget {
  const Fourth(this.id, {Key? key}) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Fourth $id'),
          TextButton(
            onPressed: () {
              Router.of(context)
                  .routeInformationParser
                  ?.parseRouteInformation(
                    const RouteInformation(
                      location: '/',
                    ),
                  )
                  .then(
                    (value) => Router.of(context)
                        .routerDelegate
                        .setNewRoutePath(value),
                  );
            },
            child: const Text('GO to main'),
          ),
        ],
      ),
    );
  }
}
