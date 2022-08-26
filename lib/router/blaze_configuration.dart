import 'package:blaze_router/misc/extenstions.dart';
import 'package:flutter/material.dart';

abstract class IBlazeConfiguration implements RouteInformation {
  IBlazeConfiguration({
    required this.location,
    this.state = const <String, dynamic>{},
  });

  @override
  final String location;

  /// Just Route Information`s state aka extra object.
  @override
  final Map<String, dynamic> state;

  /// Query params for current configuration
  /// Unmodiable map
  Map<String, String> get queryParams;

  bool get isFirst;

  RouteInformation toRouteInformation();

  @override
  String toString() => '$runtimeType(location: $location, state: $state)';
}

abstract class BaseBlazeConfiguration extends IBlazeConfiguration {
  BaseBlazeConfiguration({
    required super.location,
    super.state,
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

class BlazeConfiguration extends BaseBlazeConfiguration {
  BlazeConfiguration({
    required super.location,
    super.state,
  });

  BlazeConfiguration withQueryParams([
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
    );
  }
}
