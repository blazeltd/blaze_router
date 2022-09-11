import 'package:blaze_router/blaze_router.dart';
import 'package:flutter/material.dart';

final routes = <IBlazeRoute>[
  BlazeNestedRoute(
    path: '/',
    emptyPage: (configuration) {
      return const MaterialPage(
        child: MainDefault(),
      );
    },
    buildPage: (_, pages) => MaterialPage(
      child: Main(
        key: const ValueKey('misha1'),
        pages: pages ?? [],
      ),
    ),
    children: [
      BlazeNestedRoute(
        path: '/heyho',
        buildPage: (_, pages) => MaterialPage(
          child: NestedWrapper(
            key: const ValueKey('misha'),
            pages: pages ?? [],
          ),
        ),
        children: [
          BlazeRoute(
            path: '/first',
            buildPage: (configuration, pages) => const MaterialPage(
              child: Check(text: 'First'),
            ),
          ),
          BlazeRoute(
            path: '/second',
            buildPage: (configuration, pages) => const MaterialPage(
              child: Check(text: 'Second'),
            ),
          ),
        ],
      ),
      BlazeRoute(
        path: '/home',
        buildPage: (configuration, pages) => const MaterialPage(
          child: Check(
            text: 'Home',
            key: Key('home'),
          ),
        ),
      ),
      BlazeRoute(
        path: '/bolt',
        buildPage: (configuration, pages) => const MaterialPage(
          child: Check(
            text: 'Bolt',
            key: Key('Bolt'),
          ),
        ),
      ),
    ],
  ),
];

class Main extends StatelessWidget {
  const Main({
    required this.pages,
    super.key,
  });

  final List<Page<Object>> pages;

  @override
  Widget build(BuildContext context) {
    final loc = BlazeRouter.of(context).location;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Navigator(
              pages: pages,
              onPopPage: (route, result) {
                return route.didPop(result);
              },
            ),
          ),
          BottomNavigationBar(
            onTap: (index) {
              final router = BlazeRouter.of(context);
              if (index == 0) {
                router.push('/home');
              }
              if (index == 1) {
                router.push('/bolt');
              }
            },
            currentIndex: (loc.startsWith('/home') ||
                    loc == ('/') ||
                    loc.split('/')[1] != 'home' && loc.split('/')[1] != 'bolt')
                ? 0
                : 1,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bolt),
                label: 'Bolt',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NestedWrapper extends StatelessWidget {
  const NestedWrapper({
    required this.pages,
    super.key,
  });

  final List<Page<Object>> pages;

  @override
  Widget build(BuildContext context) {
    final router = BlazeRouter.of(context);
    final f = router.location.split('/')[1];
    final loc = BlazeRouter.of(context).location;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Navigator(
              pages: pages,
              onPopPage: (route, result) {
                return route.didPop(result);
              },
            ),
          ),
          BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                router.push('/$f/first');
              }
              if (index == 1) {
                router.push('/$f/second');
              }
            },
            currentIndex: (loc == '/$f/first' || loc == '/$f') ? 0 : 1,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'First',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bolt),
                label: 'Second',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// {@template routes}
/// MainDefault widget
/// {@endtemplate}
class MainDefault extends StatelessWidget {
  /// {@macro routes}
  const MainDefault({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        child: const Text('open new nested'),
        onPressed: () {
          BlazeRouter.of(context).push('/heyho');
        },
      );
} // MainDefault

/// {@template routes}
/// Check widget
/// {@endtemplate}
class Check extends StatelessWidget {
  /// {@macro routes}
  const Check({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: text == 'Home' ? Colors.red : Colors.blue,
        child: Column(
          children: [
            Text(text),
            TextButton(
              onPressed: BlazeRouter.of(context).pop,
              child: const Text('Pop'),
            ),
          ],
        ),
      );
} // Check

