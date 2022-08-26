import 'package:flutter/material.dart';

typedef CustomBlazePageBuilder<T> = Route<T> Function(
  BuildContext context,
);

typedef BlazeDialogPageBuilder = Widget Function(
  BuildContext context,
);

class CustomBlazePage<T> extends Page<T> {
  const CustomBlazePage({required this.buildRoute});

  final CustomBlazePageBuilder<T> buildRoute;

  @override
  Route<T> createRoute(BuildContext context) => buildRoute(context);
}

class BlazeDialogPage<T> extends Page<T> {
  const BlazeDialogPage({required this.builder});
  final BlazeDialogPageBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute(
        context: context,
        settings: this,
        builder: builder,
      );
}
