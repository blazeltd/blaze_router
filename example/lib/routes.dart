import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:blaze_router/router/page.dart';
import 'package:flutter/material.dart';

final routes = [
  BlazeRoute(
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
          path: '/2dad',
          buildPage: (_) => const MaterialPage(
            child: Main(),
          ),
        ),
        BlazeRoute(
          path: '/fdzfsd',
          buildPage: (_) => const MaterialPage(
            child: Main(),
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
                Router.of(context).routerDelegate.setNewRoutePath(
                      BlazeConfiguration(
                        location: '/second',
                      ),
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
              Router.of(context).routerDelegate.setNewRoutePath(
                    BlazeConfiguration(
                      location: '/third',
                    ).withQueryParams(
                      <String, String>{
                        'aboba': 'jopapopa',
                      },
                    ),
                  );
            },
            child: const Text('GO to main'),
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
              Router.of(context).routerDelegate.setNewRoutePath(
                    BlazeConfiguration(
                      location: '/second',
                    ),
                  );
            },
            child: const Text('GO to second'),
          ),
        ],
      ),
    );
  }
}
