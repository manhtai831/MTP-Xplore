import 'package:device_explorer/application.dart';
import 'package:device_explorer/src/common/translate/translate.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Translate().initialize();
  runApp(const Application());
}
