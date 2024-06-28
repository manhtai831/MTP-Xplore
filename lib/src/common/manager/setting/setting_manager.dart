import 'dart:convert';
import 'dart:io';

import 'package:device_explorer/src/common/base/provider_extension.dart';
import 'package:device_explorer/src/model/setting_model.dart';
import 'package:path_provider/path_provider.dart';

class SettingManager {
  SettingManager._();

  static final SettingManager _singleton = SettingManager._();

  factory SettingManager() => _singleton;

  String? appPath;

  SettingModel _settings = SettingModel();

  SettingModel get settings => _settings;

  Directory get tmpDir => Directory('$appPath/tmp');
  Directory get settingDir => Directory('$appPath/settings');
  File get settingFile => File('${settingDir.path}/setting.json');

  Future<void> init() async {
    appPath = (await getApplicationSupportDirectory()).path;
    showLog(appPath);
    if (!settingDir.existsSync()) {
      settingDir.createSync();
    }
    if (!tmpDir.existsSync()) {
      tmpDir.createSync();
    }
    if (!settingFile.existsSync()) {
      settingFile.createSync();
    }
    await readSetting();
  }

  Future<void> updateSetting(SettingModel setting) async {
    _settings = setting;
    settingFile.writeAsStringSync(jsonEncode(setting.toJson()));
  }

  Future<void> readSetting() async {
    final content = settingFile.readAsStringSync();
    if (content.isEmpty) return;
    final map = jsonDecode(content);
    _settings = SettingModel.fromJson(map);
  }
}
