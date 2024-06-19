import 'package:device_explorer/src/model/tab_model.dart';

class TabManager {
  TabManager._();

  static final TabManager _singleton = TabManager._();

  factory TabManager() => _singleton;

}
