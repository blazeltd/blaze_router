import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
import 'package:flutter/material.dart';

abstract class IBlazeConfiguration<T> implements RouteInformation {
  IBlazeConfiguration({
    required this.location,
    required this.mathedRoutes,
    this.state = const <String, dynamic>{},
    this.pathParams = const <String, String>{},
  });

  @override
  final String location;

  /// Just Route Information`s state aka extra object.
  @override
  final Map<String, dynamic> state;

  /// Query params for current configuration
  /// Unmodiable map
  Map<String, String> get queryParams;

  /// Path params for current configuration
  /// Unmodiable map
  final Map<String, String> pathParams;

  final List<IBlazeRoute<T>> mathedRoutes;

  bool get isFirst;

  RouteInformation toRouteInformation();

  @override
  String toString() => '$runtimeType(location: $location, state: $state)';
}

abstract class BaseBlazeConfiguration<T> extends IBlazeConfiguration<T> {
  BaseBlazeConfiguration({
    required super.location,
    super.mathedRoutes = const [],
    super.state,
    super.pathParams,
  });

  @override
  bool get isFirst => location.isEmptyRoute;

  @override
  RouteInformation toRouteInformation() => RouteInformation(
        location: location,
        state: state,
      );

  @override
  Map<String, String> get queryParams => Uri.parse(location).queryParameters;
}

class BlazeConfiguration<T> extends BaseBlazeConfiguration<T> {
  BlazeConfiguration({
    required super.location,
    super.mathedRoutes,
    super.state,
    super.pathParams,
  });

  BlazeConfiguration<T> withQueryParams([
    final Map<String, String> queryParams = const <String, String>{},
  ]) {
    final uri = Uri.parse(location);
    final newUri = uri.replace(
      queryParameters: <String, String>{
        ...uri.queryParameters,
        ...queryParams,
      },
    );
    return BlazeConfiguration(
      location: newUri.toString(),
      state: state,
      mathedRoutes: mathedRoutes,
    );
  }
}
