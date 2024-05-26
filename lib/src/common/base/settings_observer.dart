import 'package:device_explorer/src/model/setting_model.dart';
import 'package:flutter/material.dart';

class SettingsObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    SettingModel().settings = route.settings;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    SettingModel().settings = previousRoute?.settings;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    SettingModel().settings = newRoute?.settings;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    SettingModel().settings = previousRoute?.settings;
  }
}
