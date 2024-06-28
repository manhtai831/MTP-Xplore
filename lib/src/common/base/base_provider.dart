import 'package:device_explorer/src/model/route_setting_model.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool mounted = false;
  late BuildContext context;

  dynamic getArguments() => RouteSettingModel().settings?.arguments;

  Future<void> init() async {}

  Future<void> onViewCreated() async {}

  void destroy() {}

  void notify() {
    if (mounted) notifyListeners();
  }
}
