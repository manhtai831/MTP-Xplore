import 'package:flutter/material.dart';

class RouteSettingModel {
  RouteSettingModel._();

  static final RouteSettingModel _singleton = RouteSettingModel._();

  factory RouteSettingModel() => _singleton;

  RouteSettings? _settings;
  set settings(RouteSettings? settings) {
    _settings = settings;
  }

  RouteSettings? get settings => _settings;
}
