import 'dart:async';

import 'package:flutter/material.dart';

class RouteSettingModel {
  RouteSettingModel._();

  static final RouteSettingModel _singleton = RouteSettingModel._();

  factory RouteSettingModel() => _singleton;
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
