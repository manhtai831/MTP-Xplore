import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/shell/shell_manager.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ShellManager().init();
  runApp(const Application());
}
