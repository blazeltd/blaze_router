import 'package:blaze_router/blaze_router.dart';

class BlazeInneringError extends Error {
  BlazeInneringError(this.maxInnering, this.yourInnering)
      : assert(
          yourInnering > maxInnering,
          'Your innering is less or equals max innering',
        );

  final int maxInnering;
  final int yourInnering;

  @override
  String toString() => 'BlazeInneringError: maxInnering = $maxInnering '
      'while yourInnering = $yourInnering';
}

class EmptyBuildPageError extends Error {
  EmptyBuildPageError(this.route);

  final IBlazeRoute? route;

  @override
  String toString() => 'EmptyBuildPageError: page = $route';
}
