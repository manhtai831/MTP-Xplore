import 'package:flutter/material.dart';

class SettingModel {
  SettingModel._();

  static final SettingModel _singleton = SettingModel._();

  factory SettingModel() => _singleton;
  
  RouteSettings? settings;
}
