import 'package:device_explorer/src/model/setting_model.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool mounted = false;
  late BuildContext context;

  dynamic getArguments() => SettingModel().settings?.arguments;

  Future<void> init() async {}

  Future<void> onViewCreated() async {}

  void destroy() {}

  void notify() {
    if (mounted) notifyListeners();
  }
}
