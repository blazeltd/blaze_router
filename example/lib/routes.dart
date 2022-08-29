import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/router/page.dart';
import 'package:blaze_router/router/router.dart';
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
                BlazeRouter.of(context).push('/second');
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
              BlazeRouter.of(context).push(
                '/third',
                queryParams: {'aboba': 'aboba'},
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
              BlazeRouter.of(context).push('/second/123');
            },
            child: const Text('Go to Fourth(second with path params)'),
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
              BlazeRouter.of(context).pop();
            },
            child: const Text('POP'),
          ),
        ],
      ),
    );
  }
}
