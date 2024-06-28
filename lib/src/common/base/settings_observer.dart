import 'package:device_explorer/src/model/route_setting_model.dart';
import 'package:flutter/material.dart';

class SettingsObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    RouteSettingModel().settings = route.settings;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    RouteSettingModel().settings = previousRoute?.settings;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    RouteSettingModel().settings = newRoute?.settings;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    RouteSettingModel().settings = previousRoute?.settings;
  }
}
