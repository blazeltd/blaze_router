import 'package:blaze_router/blaze_router.dart';
import 'package:blaze_router/misc/extenstions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
abstract class IBlazeConfiguration implements RouteInformation {
  const IBlazeConfiguration({
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

  final List<IBlazeRoute> mathedRoutes;

  bool get isFirst;

  RouteInformation toRouteInformation();

  BlazeConfiguration withQueryParams([
    final Map<String, String>? queryParams,
  ]);

  /// copywith
  BlazeConfiguration copyWith({
    String? location,
    Map<String, dynamic>? state,
    Map<String, String>? pathParams,
    List<IBlazeRoute>? mathedRoutes,
  });

  @override
  String toString() => '$runtimeType(location: $location, '
      'state: $state, '
      'pathParams: $pathParams)';

  @override
  int get hashCode => Object.hash(
        location,
        state,
        queryParams,
        pathParams,
        mathedRoutes,
      );

  @override
  bool operator ==(Object other) =>
      other is IBlazeConfiguration &&
      const DeepCollectionEquality().equals(location, other.location) &&
      const DeepCollectionEquality().equals(state, other.state) &&
      const DeepCollectionEquality().equals(queryParams, other.queryParams) &&
      const DeepCollectionEquality().equals(pathParams, other.pathParams) &&
      const DeepCollectionEquality().equals(mathedRoutes, other.mathedRoutes);
}

abstract class BaseBlazeConfiguration extends IBlazeConfiguration {
  const BaseBlazeConfiguration({
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
  BlazeConfiguration withQueryParams([
    final Map<String, String>? queryParams,
  ]) {
    final uri = Uri.parse(location);
    final qParams = <String, String>{
      ...uri.queryParameters,
      ...?queryParams,
    };
    final newUri = uri.replace(
      queryParameters: qParams.isEmpty ? null : qParams,
    );
    return copyWith(location: newUri.toString());
  }

  @override
  BlazeConfiguration copyWith({
    String? location,
    Map<String, dynamic>? state,
    Map<String, String>? pathParams,
    List<IBlazeRoute>? mathedRoutes,
  }) =>
      BlazeConfiguration(
        location: location ?? this.location,
        state: state ?? this.state,
        pathParams: pathParams ?? this.pathParams,
        mathedRoutes: mathedRoutes ?? this.mathedRoutes,
      );

  @override
  Map<String, String> get queryParams => Uri.parse(location).queryParameters;
}

class BlazeConfiguration extends BaseBlazeConfiguration {
  const BlazeConfiguration({
    required super.location,
    super.mathedRoutes,
    super.state,
    super.pathParams,
  });
}
