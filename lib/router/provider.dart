import 'package:blaze_router/misc/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlazeInformationProvider extends RouteInformationProvider
    with WidgetsBindingObserver, ChangeNotifier {
  /// Create a platform route information provider.
  ///
  /// Use the [initialRouteInformation] to set the default route information
  /// for this
  /// provider.
  BlazeInformationProvider({
    required RouteInformation initialRouteInformation,
  }) : _value = initialRouteInformation;

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    final replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none &&
            _valueInEngine.location == routeInformation.location);
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      location: routeInformation.location!,
      state: routeInformation.state,
      replace: replace,
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  RouteInformation get value => _value;
  RouteInformation _value;

  RouteInformation _valueInEngine = RouteInformation(
    location: WidgetsBinding.instance.platformDispatcher.defaultRouteName,
  );

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    l('_platformReportsNewRouteInformation ${routeInformation.location} ${routeInformation.state}');
    if (_value == routeInformation) return;
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) WidgetsBinding.instance.addObserver(this);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void dispose() {
    // In practice, this will rarely be called. We assume that the listeners
    // will be added and removed in a coherent fashion such that when the object
    // is no longer being used, there's no listener, and so it will get garbage
    // collected.
    if (hasListeners) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(
    RouteInformation routeInformation,
  ) async {
    _platformReportsNewRouteInformation(routeInformation);
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    _platformReportsNewRouteInformation(RouteInformation(location: route));
    return true;
  }
}
