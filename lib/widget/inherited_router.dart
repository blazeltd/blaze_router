import 'package:blaze_router/router/router.dart';
import 'package:flutter/material.dart';

class InheritedBlazeRouter extends InheritedWidget {
  const InheritedBlazeRouter({
    super.key,
    required super.child,
    required this.router,
  });

  final IBlazeRouter router;

  @override
  bool updateShouldNotify(covariant InheritedBlazeRouter oldWidget) =>
      router != oldWidget.router;
}
