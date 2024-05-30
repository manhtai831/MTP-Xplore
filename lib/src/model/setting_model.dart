import 'dart:async';

import 'package:flutter/material.dart';

class SettingModel {
  SettingModel._();

  static final SettingModel _singleton = SettingModel._();

  factory SettingModel() => _singleton;
  StreamController controller = StreamController.broadcast();

  RouteSettings? _settings;
  set settings(RouteSettings? settings) {
    bool mustSink = settings?.name != _settings?.name;
    _settings = settings;

    if (mustSink) {
      controller.add('ok');
    }
  }

  RouteSettings? get settings => _settings;
}
