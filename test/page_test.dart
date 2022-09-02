import 'package:blaze_router/router/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pages tests', () {
    testWidgets('custom blaze page', (tester) async {
      final page = CustomBlazePage<Object>(
        buildRoute: (context) => DialogRoute(
          context: context,
          builder: (ctx) => const Text('test'),
        ),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: PageTest(),
        ),
      );
      expect(
        page.createRoute(tester.element(find.byType(PageTest))),
        isInstanceOf<DialogRoute<Object>>(),
      );
    });
    testWidgets('custom dialog page', (tester) async {
      final page = BlazeDialogPage<Object>(
        builder: (context) => const Text('test'),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: PageTest(),
        ),
      );
      expect(
        page.createRoute(tester.element(find.byType(PageTest))),
        isInstanceOf<DialogRoute<Object>>(),
      );
    });
  });
}

/// {@template page_test}
/// PageTest widget
/// {@endtemplate}
class PageTest extends StatelessWidget {
  /// {@macro page_test}
  const PageTest({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
} // PageTest
